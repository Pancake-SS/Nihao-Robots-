import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/robot_art.dart';
import '../vocabulary/learning_keyboard.dart';
import '../vocabulary/vocabulary_repository.dart';
import '../vocabulary/word_introduction_screen.dart';
import 'learning.dart';
import 'learning_providers.dart';
import 'practice_deck.dart';
import 'practice_repository.dart';
import 'practice_session_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({
    required this.profileId,
    this.showPinyin = true,
    super.key,
  });
  final int profileId;
  final bool showPinyin;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const AppScreenTitle('Practice')),
    body: WarmPageBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: PracticeContent(
              profileId: profileId,
              showPinyin: showPinyin,
            ),
          ),
        ),
      ),
    ),
  );
}

class PracticeContent extends ConsumerStatefulWidget {
  const PracticeContent({
    required this.profileId,
    required this.showPinyin,
    super.key,
  });
  final int profileId;
  final bool showPinyin;
  @override
  ConsumerState<PracticeContent> createState() => _PracticeContentState();
}

class _PracticeContentState extends ConsumerState<PracticeContent> {
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

  Future<void> _searchWords() async {
    final query = _search.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results = null;
        _page = 0;
        _message = null;
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
          .relearnSearch(widget.profileId, query);
      if (mounted)
        setState(() {
          _results = results;
          _selected = results.firstOrNull?.id;
        });
    } catch (_) {
      if (mounted)
        setState(() => _message = 'Could not search your words. Try again.');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _start(PracticeMode mode, List<WordProgress> words) {
    if (words.isEmpty) return;
    final count = mode == PracticeMode.randomWords
        ? int.tryParse(_count.text.trim())
        : null;
    if (mode == PracticeMode.randomWords &&
        (count == null || count < 1 || count > words.length)) {
      setState(() => _message = 'Enter a number from 1 to ${words.length}.');
      return;
    }
    if (mode == PracticeMode.singleWord &&
        !words.any((word) => word.wordId == _selected)) {
      setState(() => _message = 'Choose a learned word first.');
      return;
    }
    setState(() => _message = null);
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => PracticeSessionScreen(
              profileId: widget.profileId,
              mode: mode,
              wordIds: mode == PracticeMode.singleWord
                  ? [_selected!]
                  : [for (final word in words) word.wordId],
              count: count ?? 0,
            ),
          ),
        )
        .then((_) {
          if (mounted)
            ref.invalidate(learningProgressProvider(widget.profileId));
        });
  }

  Future<void> _relearn(List<WordProgress> words) async {
    if (_selected == null ||
        !words.any((word) => word.wordId == _selected) ||
        _results?.any((word) => word.id == _selected) != true) {
      setState(
        () =>
            _message = 'Search by Hanzi or English and choose a learned word.',
      );
      return;
    }
    final lesson = await ref.read(vocabularyLessonProvider(_selected!).future);
    if (!mounted) return;
    if (lesson == null) {
      setState(() => _message = 'This lesson is unavailable right now.');
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordIntroductionScreen(
          word: lesson,
          showPinyin: widget.showPinyin,
          profileId: widget.profileId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(learningProgressProvider(widget.profileId));
    return progress.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Column(
        children: [
          const Text(
            'Could not load learned words. Your saved data is intact.',
          ),
          TextButton(
            onPressed: () =>
                ref.invalidate(learningProgressProvider(widget.profileId)),
            child: const Text('Try again'),
          ),
        ],
      ),
      data: (words) {
        final pageWords = words.skip(_page * 20).take(20).toList();
        final ids = _results == null
            ? [for (final word in pageWords) word.wordId]
            : [for (final word in _results!) word.id];
        final scores = {
          for (final word in words) word.wordId: word.correctCount,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SunnyHero(
              title: 'Practice',
              subtitle:
                  'Choose what to revisit, or let the questions surprise you.',
              tag: 'Your learned words',
              robot: RobotArtwork.orbOnPaper,
            ),
            const SizedBox(height: 18),
            Text(
              '${words.length} learned words',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (words.isEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Learn a word and finish its first quiz to begin practising.',
              ),
            ] else ...[
              const SizedBox(height: 20),
              Text(
                '1 · Test a word again',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text('Select a word below to replay all its questions.'),
              const SizedBox(height: 12),
              LearningKeyboard(
                hanzi: _search,
                enabled: !_searching,
                hanziLabel: 'Find a learned word',
                hanziHint: 'Hanzi or English meaning',
                hanziSuffixIcon: IconButton(
                  tooltip: 'Find learned word',
                  icon: const Icon(Icons.search),
                  onPressed: _searching ? null : _searchWords,
                ),
                onHanziSubmitted: (_) => _searchWords(),
              ),
              if (_searching) const LinearProgressIndicator(),
              if (_results != null)
                TextButton(
                  onPressed: () {
                    _search.clear();
                    _searchWords();
                  },
                  child: const Text('Show all learned words'),
                ),
              if (_results?.isEmpty == true)
                const Text(
                  'No learned word matches that Hanzi or English meaning.',
                ),
              ExpansionTile(
                key: ValueKey(
                  _results == null
                      ? 'browse-learned-words'
                      : 'matching-learned-words',
                ),
                title: Text(
                  _results == null
                      ? 'Browse learned words'
                      : 'Matching learned words',
                ),
                initiallyExpanded: _results != null,
                children: [
                  for (final id in ids)
                    Builder(
                      builder: (context) {
                        final word = ref
                            .watch(vocabularyLessonProvider(id))
                            .asData
                            ?.value;
                        final result = _results
                            ?.where((row) => row.id == id)
                            .firstOrNull;
                        return Card(
                          color: _selected == id
                              ? AppColors.paleGreen
                              : AppColors.paper,
                          child: ListTile(
                            key: ValueKey('practice-word-$id'),
                            selected: _selected == id,
                            title: Text(
                              word?.entry.hanzi ??
                                  result?.hanzi ??
                                  'Loading word…',
                            ),
                            subtitle: Text(
                              word?.entry.meaning ?? result?.meaning ?? '',
                            ),
                            trailing: Text('${scores[id] ?? 0} correct'),
                            onTap: () => setState(() => _selected = id),
                          ),
                        );
                      },
                    ),
                  if (_results == null && words.length > 20)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _page == 0
                              ? null
                              : () => setState(() => _page--),
                          child: const Text('Previous 20'),
                        ),
                        Text('Page ${_page + 1}'),
                        TextButton(
                          onPressed: (_page + 1) * 20 >= words.length
                              ? null
                              : () => setState(() => _page++),
                          child: const Text('Next 20'),
                        ),
                      ],
                    ),
                ],
              ),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: _selected == null
                        ? null
                        : () => _start(PracticeMode.singleWord, words),
                    child: const Text('Test selected word'),
                  ),
                  OutlinedButton(
                    onPressed:
                        _results?.any((word) => word.id == _selected) == true
                        ? () => _relearn(words)
                        : null,
                    child: const Text('Relearn selected word'),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'To relearn, search by Hanzi or English and choose a result.',
              ),
              const Divider(height: 40),
              Text(
                '2 · Random words',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how many questions. Each comes from a different learned word.',
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 160,
                child: TextField(
                  key: const ValueKey('random-question-count'),
                  controller: _count,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Questions'),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  onPressed: () => _start(PracticeMode.randomWords, words),
                  child: const Text('Start random practice'),
                ),
              ),
              const Divider(height: 40),
              Text(
                '3 · Endless random',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Keep going through fresh questions. A question only returns if you need to correct it.',
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  onPressed: () => _start(PracticeMode.endless, words),
                  child: const Text('Start endless practice'),
                ),
              ),
            ],
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(_message!, key: const ValueKey('practice-message')),
              ),
          ],
        );
      },
    );
  }
}
