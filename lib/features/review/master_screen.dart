import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/context_tour.dart';
import '../../shared/robot_art.dart';
import '../vocabulary/learning_keyboard.dart';
import '../vocabulary/vocabulary_repository.dart';
import 'learning_providers.dart';
import 'mastered_words_screen.dart';
import 'master_repository.dart';
import 'master_test_screen.dart';
import 'practice_method_screen.dart';

class MasterScreen extends ConsumerWidget {
  MasterScreen({required this.profileId, required this.showPinyin, super.key});
  final int profileId;
  final bool showPinyin;
  final _targets = List.generate(4, (_) => GlobalKey());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(learningProgressProvider(profileId));
    final mastered = ref.watch(masteredIdsProvider(profileId));
    final ids = mastered.asData?.value ?? <String>{};
    final eligible = progress.asData?.value
        .where(
          (word) =>
              word.correctCount >= masterPointGoal &&
              !ids.contains(word.wordId),
        )
        .length;
    return Scaffold(
      appBar: AppBar(
        title: const AppScreenTitle('Master'),
        actions: [
          IconButton(
            tooltip: 'Page tutorial',
            onPressed: () => showContextTour(context, [
              TourStop(
                _targets[0],
                'Ready words',
                'Words with $masterPointGoal correct quiz answers can take the Master test.',
              ),
              TourStop(
                _targets[1],
                'Instant master',
                'Already know a word? Confirm to move it straight into Master without a quiz.',
              ),
              TourStop(
                _targets[2],
                'Mastered words',
                'See the words in Master and practice one again.',
              ),
              TourStop(
                _targets[3],
                'Keep words sharp',
                'A mastered word can return to Learn after three missed answers in its review.',
              ),
            ]),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SunnyHero(
                  title: 'Master',
                  subtitle: 'Prove you know a word and keep it sharp.',
                  tag: 'Remember for longer',
                  robot: RobotArtwork.gogglesOnPaper,
                ),
                const SizedBox(height: 18),
                Text(
                  'A word is ready after $masterPointGoal correct answers. Pass its full quiz to move it into Master.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                _tile(
                  context,
                  _targets[0],
                  Icons.emoji_events_outlined,
                  'Ready for Master test',
                  eligible == null
                      ? 'Loading…'
                      : '$eligible words with $masterPointGoal or more points',
                  () => MasterCandidatesScreen(
                    profileId: profileId,
                    instant: false,
                  ),
                ),
                _tile(
                  context,
                  _targets[1],
                  Icons.flash_on_outlined,
                  'Instant master',
                  'Already know a word? Move it to Master after confirming.',
                  () => MasterCandidatesScreen(
                    profileId: profileId,
                    instant: true,
                  ),
                ),
                _tile(
                  context,
                  _targets[2],
                  Icons.collections_bookmark_outlined,
                  'Mastered words',
                  '${ids.length} words in Master · Practice one again',
                  () => MasteredWordsScreen(
                    profileId: profileId,
                    showPinyin: showPinyin,
                  ),
                ),
                _tile(
                  context,
                  _targets[3],
                  Icons.fitness_center_outlined,
                  'Practice mastered words',
                  'Three missed answers for a word return it to Learn.',
                  () => MasterPracticeScreen(
                    profileId: profileId,
                    showPinyin: showPinyin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    Key target,
    IconData icon,
    String title,
    String subtitle,
    Widget Function() page,
  ) => Card(
    key: target,
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () =>
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => page())),
    ),
  );
}

class MasterCandidatesScreen extends ConsumerStatefulWidget {
  const MasterCandidatesScreen({
    required this.profileId,
    required this.instant,
    super.key,
  });
  final int profileId;
  final bool instant;
  @override
  ConsumerState<MasterCandidatesScreen> createState() =>
      _MasterCandidatesScreenState();
}

class _MasterCandidatesScreenState
    extends ConsumerState<MasterCandidatesScreen> {
  final _search = TextEditingController();
  List<MasterWord>? _results;
  bool _loading = false;
  bool _hasMore = false;
  int _page = 0;
  int _request = 0;
  String _query = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.instant) Future.microtask(() => _loadInstantPage(0, ''));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _loadInstantPage(int page, String query) async {
    final request = ++_request;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(masterRepositoryProvider)
          .browseAvailable(widget.profileId, query: query, offset: page * 20);
      if (!mounted || request != _request) return;
      if (result.words.isEmpty && page > 0) {
        await _loadInstantPage(page - 1, query);
        return;
      }
      setState(() {
        _results = result.words;
        _hasMore = result.hasMore;
        _page = page;
        _query = query;
      });
    } catch (_) {
      if (mounted && request == _request)
        setState(() => _error = 'Could not search words. Try again.');
    } finally {
      if (mounted && request == _request) {
        setState(() => _loading = false);
      }
    }
  }

  void _find() => _loadInstantPage(0, _search.text.trim());

  Future<void> _open(String id, String hanzi) async {
    if (widget.instant) {
      await offerInstantMaster(
        context,
        profileId: widget.profileId,
        wordId: id,
        hanzi: hanzi,
      );
    } else {
      await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => MasterTestScreen(
            profileId: widget.profileId,
            wordId: id,
            hanzi: hanzi,
          ),
        ),
      );
    }
    if (mounted) {
      ref.invalidate(masteredIdsProvider(widget.profileId));
      ref.invalidate(learningProgressProvider(widget.profileId));
      if (widget.instant) _loadInstantPage(_page, _query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(learningProgressProvider(widget.profileId));
    final mastered = ref.watch(masteredIdsProvider(widget.profileId));
    final ids = mastered.asData?.value ?? <String>{};
    final eligible =
        progress.asData?.value
            .where(
              (word) =>
                  word.correctCount >= masterPointGoal &&
                  !ids.contains(word.wordId),
            )
            .toList() ??
        [];
    final visible = eligible.skip(_page * 20).take(20).toList();
    return Scaffold(
      appBar: AppBar(
        title: AppScreenTitle(
          widget.instant ? 'Instant master' : 'Ready for Master test',
        ),
      ),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  widget.instant
                      ? 'Browse words you already know, or search to find one quickly.'
                      : 'These words have earned $masterPointGoal correct points. Choose one for its Master test.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (widget.instant) ...[
                  const SizedBox(height: 14),
                  LearningKeyboard(
                    hanzi: _search,
                    enabled: !_loading,
                    hanziLabel: 'Search any word',
                    hanziHint: 'Hanzi, pinyin or English',
                    hanziSuffixIcon: IconButton(
                      tooltip: 'Find word',
                      icon: const Icon(Icons.search),
                      onPressed: _loading ? null : _find,
                    ),
                    onHanziSubmitted: (_) => _find(),
                  ),
                  if (_query.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        _search.clear();
                        _loadInstantPage(0, '');
                      },
                      child: const Text('Show all words'),
                    ),
                  if (_loading) const LinearProgressIndicator(),
                  if (_error != null) Text(_error!),
                  if (_results?.isEmpty == true)
                    const Text('No matching unmastered words.'),
                  for (final word in _results ?? <MasterWord>[])
                    Card(
                      child: ListTile(
                        key: ValueKey('instant-master-${word.id}'),
                        title: Text(word.hanzi),
                        subtitle: Text('${word.pinyin} · ${word.meaning}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _open(word.id, word.hanzi),
                      ),
                    ),
                  if (_page > 0 || _hasMore)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextButton(
                            onPressed: _loading || _page == 0
                                ? null
                                : () => _loadInstantPage(_page - 1, _query),
                            child: const Text('Previous 20'),
                          ),
                        ),
                        Text('Page ${_page + 1}'),
                        Flexible(
                          child: TextButton(
                            onPressed: _loading || !_hasMore
                                ? null
                                : () => _loadInstantPage(_page + 1, _query),
                            child: const Text('Next 20'),
                          ),
                        ),
                      ],
                    ),
                ] else ...[
                  if (progress.isLoading || mastered.isLoading)
                    const LinearProgressIndicator(),
                  if (progress.hasError || mastered.hasError)
                    TextButton(
                      onPressed: () {
                        ref.invalidate(
                          learningProgressProvider(widget.profileId),
                        );
                        ref.invalidate(masteredIdsProvider(widget.profileId));
                      },
                      child: const Text('Reload words'),
                    ),
                  if (eligible.isEmpty &&
                      !progress.isLoading &&
                      !mastered.isLoading)
                    const Text(
                      'No words are ready yet. Correct answers in lesson and Master quizzes add points.',
                    ),
                  for (final word in visible)
                    Card(
                      child: ListTile(
                        key: ValueKey('earned-master-${word.wordId}'),
                        title: Text(
                          ref
                                  .watch(vocabularyLessonProvider(word.wordId))
                                  .asData
                                  ?.value
                                  ?.entry
                                  .hanzi ??
                              'Loading word…',
                        ),
                        subtitle: Text('${word.correctCount} correct points'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final lesson = await ref.read(
                            vocabularyLessonProvider(word.wordId).future,
                          );
                          if (lesson != null && context.mounted)
                            _open(word.wordId, lesson.entry.hanzi);
                        },
                      ),
                    ),
                  if (eligible.length > 20)
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
                          onPressed: (_page + 1) * 20 >= eligible.length
                              ? null
                              : () => setState(() => _page++),
                          child: const Text('Next 20'),
                        ),
                      ],
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MasterPracticeScreen extends StatelessWidget {
  const MasterPracticeScreen({
    required this.profileId,
    required this.showPinyin,
    super.key,
  });
  final int profileId;
  final bool showPinyin;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const AppScreenTitle('Master practice')),
    body: WarmPageBackground(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Keep your words sharp',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Each mastered word has three missed-answer chances in a session. On the third miss, it returns to Learn. Correctness points stay saved.',
              ),
              const SizedBox(height: 16),
              for (final choice in <(PracticeRoute, String, String)>[
                (
                  PracticeRoute.oneWord,
                  'Test one mastered word',
                  'Repeat its full test.',
                ),
                (
                  PracticeRoute.randomWords,
                  'Random mastered questions',
                  'Choose questions from different words.',
                ),
                (
                  PracticeRoute.endless,
                  'Endless mastered questions',
                  'Continue until you stop.',
                ),
                (
                  PracticeRoute.relearn,
                  'Revisit a mastered lesson',
                  'Browse mastered words or search, then review a lesson.',
                ),
              ])
                Card(
                  child: ListTile(
                    title: Text(choice.$2),
                    subtitle: Text(choice.$3),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PracticeMethodScreen(
                          profileId: profileId,
                          route: choice.$1,
                          showPinyin: showPinyin,
                          masterMode: true,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
