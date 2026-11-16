import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../vocabulary/learning_keyboard.dart';
import '../vocabulary/vocabulary_repository.dart';
import '../vocabulary/word_introduction_screen.dart';
import 'learning.dart';
import 'learning_providers.dart';
import 'master_repository.dart';
import 'practice_deck.dart';
import 'practice_repository.dart';
import 'practice_session_screen.dart';

enum PracticeRoute { oneWord, randomWords, endless, relearn }

class PracticeMethodScreen extends ConsumerStatefulWidget {
  const PracticeMethodScreen({
    required this.profileId,
    required this.route,
    required this.showPinyin,
    this.masterMode = false,
    super.key,
  });
  final int profileId;
  final PracticeRoute route;
  final bool showPinyin, masterMode;
  @override
  ConsumerState<PracticeMethodScreen> createState() =>
      _PracticeMethodScreenState();
}

class _PracticeMethodScreenState extends ConsumerState<PracticeMethodScreen> {
  final _search = TextEditingController();
  final _count = TextEditingController(text: '1');
  List<RelearnWord>? _results;
  String? _selected, _message;
  bool _searching = false;
  int _page = 0;

  @override
  void dispose() {
    _search.dispose();
    _count.dispose();
    super.dispose();
  }

  String get _title => switch (widget.route) {
    PracticeRoute.oneWord =>
      widget.masterMode ? 'Test a mastered word' : 'Test one word',
    PracticeRoute.randomWords => 'Random questions',
    PracticeRoute.endless => 'Endless questions',
    PracticeRoute.relearn => 'Relearn a word',
  };

  Future<void> _searchWords(Set<String> available) async {
    final query = _search.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results = null;
        _selected = null;
        _page = 0;
      });
      return;
    }
    setState(() {
      _searching = true;
      _message = null;
    });
    try {
      final results = await ref
          .read(practiceRepositoryProvider)
          .relearnSearch(widget.profileId, query, mastered: widget.masterMode);
      if (mounted)
        setState(() {
          _results = results
              .where((word) => available.contains(word.id))
              .toList();
          _selected = _results!.firstOrNull?.id;
        });
    } catch (_) {
      if (mounted) setState(() => _message = 'Could not search. Try again.');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _start(PracticeMode mode, List<WordProgress> words) async {
    final ids = [for (final word in words) word.wordId];
    if (ids.isEmpty) return;
    var count = 0;
    if (mode == PracticeMode.randomWords) {
      count = int.tryParse(_count.text.trim()) ?? 0;
      if (count < 1 || count > ids.length) {
        setState(() => _message = 'Enter a number from 1 to ${ids.length}.');
        return;
      }
    }
    if (mode == PracticeMode.singleWord && !ids.contains(_selected)) {
      setState(() => _message = 'Choose a word first.');
      return;
    }
    setState(() => _message = null);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PracticeSessionScreen(
          profileId: widget.profileId,
          mode: mode,
          wordIds: mode == PracticeMode.singleWord ? [_selected!] : ids,
          count: count,
          masterPractice: widget.masterMode,
        ),
      ),
    );
    if (mounted) {
      ref.invalidate(learningProgressProvider(widget.profileId));
      ref.invalidate(masteredIdsProvider(widget.profileId));
    }
  }

  Future<void> _relearn() async {
    if (_results?.any((word) => word.id == _selected) != true) {
      setState(
        () => _message = 'Search by Hanzi or English and choose a word.',
      );
      return;
    }
    final word = await ref.read(vocabularyLessonProvider(_selected!).future);
    if (!mounted) return;
    if (word == null) {
      setState(() => _message = 'This lesson is unavailable.');
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordIntroductionScreen(
          word: word,
          showPinyin: widget.showPinyin,
          profileId: widget.profileId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(learningProgressProvider(widget.profileId));
    final mastered = ref.watch(masteredIdsProvider(widget.profileId));
    return Scaffold(
      appBar: AppBar(title: AppScreenTitle(_title)),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: progress.isLoading || mastered.isLoading
                ? const Center(child: CircularProgressIndicator())
                : progress.hasError || mastered.hasError
                ? Center(
                    child: TextButton(
                      onPressed: () {
                        ref.invalidate(
                          learningProgressProvider(widget.profileId),
                        );
                        ref.invalidate(masteredIdsProvider(widget.profileId));
                      },
                      child: const Text('Reload practice words'),
                    ),
                  )
                : _body(
                    context,
                    progress.asData!.value,
                    mastered.asData!.value,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    List<WordProgress> all,
    Set<String> mastered,
  ) {
    final words = all
        .where((word) => widget.masterMode == mastered.contains(word.wordId))
        .toList();
    final available = {for (final word in words) word.wordId};
    final ids = _results == null
        ? words.skip(_page * 20).take(20).map((word) => word.wordId).toList()
        : _results!.map((word) => word.id).toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(_title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        if (widget.masterMode)
          const Text(
            'Each mastered word has three missed-answer chances in this session. A third miss returns it to Learn; past points and writing remain saved.',
          ),
        if (widget.route == PracticeRoute.oneWord) ...[
          const Text('Pick a word, then replay all of its questions.'),
          const SizedBox(height: 14),
          _searchField(available),
          if (_results != null)
            TextButton(
              onPressed: () {
                _search.clear();
                _searchWords(available);
              },
              child: const Text('Show all words'),
            ),
          if (ids.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('No matching words yet.'),
            ),
          for (final id in ids) _wordRow(id),
          if (_results == null && words.length > 20)
            _pageControls(words.length),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _selected != null && available.contains(_selected)
                ? () => _start(PracticeMode.singleWord, words)
                : null,
            child: const Text('Start full word test'),
          ),
        ] else if (widget.route == PracticeRoute.randomWords) ...[
          Text('${words.length} words available'),
          const SizedBox(height: 12),
          const Text(
            'Choose how many questions. Each question comes from a different word.',
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 170,
            child: TextField(
              key: const ValueKey('random-question-count'),
              controller: _count,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Number of questions',
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: words.isEmpty
                ? null
                : () => _start(PracticeMode.randomWords, words),
            child: const Text('Start random questions'),
          ),
        ] else if (widget.route == PracticeRoute.endless) ...[
          Text('${words.length} words available'),
          const SizedBox(height: 12),
          const Text(
            'Keep answering fresh questions. Original questions do not repeat; missed questions return at the end of each round.',
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: words.isEmpty
                ? null
                : () => _start(PracticeMode.endless, words),
            child: const Text('Start endless questions'),
          ),
        ] else ...[
          const Text(
            'Type Hanzi or an English meaning. Pinyin is not used to match words because it can overlap.',
          ),
          const SizedBox(height: 14),
          _searchField(available),
          if (_results?.isEmpty == true)
            const Text('No learned word matches that search.'),
          for (final id in _results?.map((word) => word.id) ?? <String>[])
            _wordRow(id),
          const SizedBox(height: 12),
          FilledButton(
            onPressed:
                _selected != null &&
                    _results?.any((word) => word.id == _selected) == true
                ? _relearn
                : null,
            child: const Text('Open lesson'),
          ),
        ],
        if (_message != null) ...[
          const SizedBox(height: 12),
          Text(_message!, key: const ValueKey('practice-method-message')),
        ],
      ],
    );
  }

  Widget _searchField(Set<String> available) => Column(
    children: [
      LearningKeyboard(
        hanzi: _search,
        enabled: !_searching,
        hanziLabel: 'Find a word',
        hanziHint: 'Hanzi or English meaning',
        hanziSuffixIcon: IconButton(
          tooltip: 'Search practice words',
          icon: const Icon(Icons.search),
          onPressed: _searching ? null : () => _searchWords(available),
        ),
        onHanziSubmitted: (_) => _searchWords(available),
      ),
      if (_searching) const LinearProgressIndicator(),
    ],
  );

  Widget _wordRow(String id) {
    final lesson = ref.watch(vocabularyLessonProvider(id)).asData?.value;
    final result = _results?.where((word) => word.id == id).firstOrNull;
    return Card(
      child: ListTile(
        key: ValueKey('practice-word-$id'),
        selected: _selected == id,
        title: Text(lesson?.entry.hanzi ?? result?.hanzi ?? 'Loading word…'),
        subtitle: Text(lesson?.entry.meaning ?? result?.meaning ?? ''),
        trailing: _selected == id ? const Icon(Icons.check_circle) : null,
        onTap: () => setState(() => _selected = id),
      ),
    );
  }

  Widget _pageControls(int total) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      TextButton(
        onPressed: _page == 0 ? null : () => setState(() => _page--),
        child: const Text('Previous 20'),
      ),
      Text('Page ${_page + 1}'),
      TextButton(
        onPressed: (_page + 1) * 20 >= total
            ? null
            : () => setState(() => _page++),
        child: const Text('Next 20'),
      ),
    ],
  );
}
