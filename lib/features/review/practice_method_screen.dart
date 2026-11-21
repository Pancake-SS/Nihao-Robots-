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
  bool _hasMore = false;
  int _page = 0;
  int _request = 0;
  String _query = '';

  @override
  void initState() {
    super.initState();
    if (widget.route == PracticeRoute.oneWord ||
        widget.route == PracticeRoute.relearn) {
      Future.microtask(() => _loadPage(0, ''));
    }
  }

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

  Future<void> _loadPage(int page, String query) async {
    final request = ++_request;
    setState(() {
      _searching = true;
      _message = null;
    });
    try {
      final result = await ref
          .read(practiceRepositoryProvider)
          .browseLearned(
            widget.profileId,
            query: query,
            mastered: widget.masterMode,
            offset: page * 20,
          );
      if (mounted && request == _request) {
        if (result.words.isEmpty && page > 0) {
          await _loadPage(page - 1, query);
          return;
        }
        setState(() {
          _results = result.words;
          _hasMore = result.hasMore;
          _page = page;
          _query = query;
          _selected = _results!.firstOrNull?.id;
        });
      }
    } catch (_) {
      if (mounted && request == _request) {
        setState(() => _message = 'Could not load words. Try again.');
      }
    } finally {
      if (mounted && request == _request) {
        setState(() => _searching = false);
      }
    }
  }

  void _searchWords() => _loadPage(0, _search.text.trim());

  Future<void> _start(
    PracticeMode mode,
    List<WordProgress> words, {
    String? selectedId,
  }) async {
    final ids = [for (final word in words) word.wordId];
    final chosen = selectedId ?? _selected;
    if (ids.isEmpty) return;
    var count = 0;
    if (mode == PracticeMode.randomWords) {
      count = int.tryParse(_count.text.trim()) ?? 0;
      if (count < 1 || count > ids.length) {
        setState(() => _message = 'Enter a number from 1 to ${ids.length}.');
        return;
      }
    }
    if (mode == PracticeMode.singleWord && !ids.contains(chosen)) {
      setState(() => _message = 'Choose a word first.');
      return;
    }
    setState(() => _message = null);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PracticeSessionScreen(
          profileId: widget.profileId,
          mode: mode,
          wordIds: mode == PracticeMode.singleWord ? [chosen!] : ids,
          count: count,
          masterPractice: widget.masterMode,
        ),
      ),
    );
    if (mounted) {
      ref.invalidate(learningProgressProvider(widget.profileId));
      ref.invalidate(masteredIdsProvider(widget.profileId));
      if (widget.route == PracticeRoute.oneWord) {
        _loadPage(_page, _query);
      }
    }
  }

  Future<void> _relearn() async {
    if (_results?.any((word) => word.id == _selected) != true) {
      setState(() => _message = 'Choose a word first.');
      return;
    }
    await _relearnWord(_selected!);
  }

  Future<void> _relearnWord(String id) async {
    final word = await ref.read(vocabularyLessonProvider(id).future);
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
          const Text('Browse your learned words and choose one to test.'),
          const SizedBox(height: 14),
          _searchField(),
          if (_query.isNotEmpty)
            TextButton(
              onPressed: () {
                _search.clear();
                _loadPage(0, '');
              },
              child: const Text('Show all words'),
            ),
          if (_results?.isEmpty == true)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('No matching learned words.'),
            ),
          if (_results == null && _searching)
            const Center(child: CircularProgressIndicator()),
          for (final word in _results ?? <RelearnWord>[]) _wordRow(word, words),
          if (_page > 0 || _hasMore) _pageControls(),
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
            'Browse words to revisit a lesson. Search by Hanzi or English to narrow the list.',
          ),
          const SizedBox(height: 14),
          _searchField(),
          if (_query.isNotEmpty)
            TextButton(
              onPressed: () {
                _search.clear();
                _loadPage(0, '');
              },
              child: const Text('Show all words'),
            ),
          if (_results?.isEmpty == true)
            const Text('No learned word matches that search.'),
          if (_results == null && _searching)
            const Center(child: CircularProgressIndicator()),
          for (final word in _results ?? <RelearnWord>[]) _wordRow(word, words),
          if (_page > 0 || _hasMore) _pageControls(),
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

  Widget _searchField() => Column(
    children: [
      LearningKeyboard(
        hanzi: _search,
        enabled: !_searching,
        hanziLabel: 'Find a word',
        hanziHint: 'Hanzi or English meaning',
        hanziSuffixIcon: IconButton(
          tooltip: 'Search practice words',
          icon: const Icon(Icons.search),
          onPressed: _searching ? null : _searchWords,
        ),
        onHanziSubmitted: (_) => _searchWords(),
      ),
      if (_searching) const LinearProgressIndicator(),
    ],
  );

  Widget _wordRow(RelearnWord word, List<WordProgress> words) {
    final id = word.id;
    final relearn = widget.route == PracticeRoute.relearn;
    return Card(
      child: ListTile(
        key: ValueKey('practice-word-$id'),
        selected: _selected == id,
        title: Text(word.hanzi),
        subtitle: Text(
          [
            if (widget.showPinyin) word.pinyin,
            word.meaning,
          ].where((part) => part.isNotEmpty).join(' · '),
        ),
        trailing: IconButton(
          tooltip: relearn ? 'Open ${word.hanzi} lesson' : 'Test ${word.hanzi}',
          icon: Icon(relearn ? Icons.menu_book_outlined : Icons.play_arrow),
          onPressed: () => relearn
              ? _relearnWord(id)
              : _start(PracticeMode.singleWord, words, selectedId: id),
        ),
        onTap: () => setState(() => _selected = id),
      ),
    );
  }

  Widget _pageControls() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: TextButton(
          onPressed: _searching || _page == 0
              ? null
              : () => _loadPage(_page - 1, _query),
          child: const Text('Previous 20'),
        ),
      ),
      Text('Page ${_page + 1}'),
      Flexible(
        child: TextButton(
          onPressed: _searching || !_hasMore
              ? null
              : () => _loadPage(_page + 1, _query),
          child: const Text('Next 20'),
        ),
      ),
    ],
  );
}
