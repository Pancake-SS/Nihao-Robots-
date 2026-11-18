import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/context_tour.dart';
import '../../shared/learning_card.dart';
import '../../shared/robot_art.dart';
import '../vocabulary/learning_keyboard.dart';
import '../vocabulary/sentence_audio.dart';
import 'grammar_repository.dart';

class GrammarHomeContent extends ConsumerWidget {
  const GrammarHomeContent({
    required this.profileId,
    required this.showPinyin,
    super.key,
  });
  final int profileId;
  final bool showPinyin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(grammarCountsProvider(profileId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SunnyHero(
          title: 'Grammar',
          subtitle: 'Learn how Mandarin sentences fit together, one pattern at a time.',
          tag: 'Sentence patterns',
          robot: RobotArtwork.trackedOnPaper,
        ),
        const SizedBox(height: 18),
        Text(
          'Your grammar lessons',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 6),
        const Text(
          'Study any pending lesson. Mark it completed when you understand the pattern; revisit it whenever you like.',
        ),
        const SizedBox(height: 15),
        if (counts.isLoading) const LinearProgressIndicator(),
        if (counts.hasError)
          TextButton(
            onPressed: () => ref.invalidate(grammarCountsProvider(profileId)),
            child: const Text('Could not load grammar lessons. Try again.'),
          ),
        _section(
          context,
          false,
          Icons.auto_stories_outlined,
          'Pending lessons',
          counts.asData?.value.pending,
          'Start with the basics, or search for a pattern you need.',
        ),
        _section(
          context,
          true,
          Icons.check_circle_outline,
          'Completed lessons',
          counts.asData?.value.completed,
          'Revisit explanations and examples you have already studied.',
        ),
      ],
    );
  }

  Widget _section(
    BuildContext context,
    bool completed,
    IconData icon,
    String title,
    int? count,
    String description,
  ) => Card(
    child: ListTile(
      key: ValueKey(completed ? 'grammar-completed' : 'grammar-pending'),
      contentPadding: const EdgeInsets.all(16),
      leading: Icon(icon, size: 30),
      title: Text(
        count == null ? title : '$title · $count',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => GrammarListScreen(
            profileId: profileId,
            completed: completed,
            showPinyin: showPinyin,
          ),
        ),
      ),
    ),
  );
}

class GrammarListScreen extends ConsumerStatefulWidget {
  const GrammarListScreen({
    required this.profileId,
    required this.completed,
    required this.showPinyin,
    super.key,
  });
  final int profileId;
  final bool completed, showPinyin;
  @override
  ConsumerState<GrammarListScreen> createState() => _GrammarListScreenState();
}

class _GrammarListScreenState extends ConsumerState<GrammarListScreen> {
  final _searchTarget = GlobalKey();
  final _filtersTarget = GlobalKey();
  final _search = TextEditingController();
  late Future<GrammarPage> _results;
  late Future<List<String>> _categories;
  int _page = 0;
  int? _level;
  String? _category;

  @override
  void initState() {
    super.initState();
    _categories = ref.read(grammarRepositoryProvider).categories();
    _results = _query();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<GrammarPage> _query() => ref
      .read(grammarRepositoryProvider)
      .page(
        widget.profileId,
        completed: widget.completed,
        page: _page,
        search: _search.text,
        level: _level,
        category: _category,
      );

  void _refresh({bool resetPage = false}) {
    setState(() {
      if (resetPage) _page = 0;
      _results = _query();
    });
    ref.invalidate(grammarCountsProvider(widget.profileId));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: AppScreenTitle(
        widget.completed ? 'Completed grammar' : 'Pending grammar',
      ),
      actions: [
        IconButton(
          tooltip: 'Page tutorial',
          onPressed: () => showContextTour(context, [
            TourStop(
              _searchTarget,
              'Search lessons',
              'Find a pattern by Chinese text or English explanation. The Chinese keyboard offers Hanzi suggestions.',
            ),
            TourStop(
              _filtersTarget,
              'Narrow the lessons',
              'Choose an HSK level or category, then tap a lesson below.',
            ),
          ]),
          icon: const Icon(Icons.help_outline),
        ),
      ],
    ),
    body: WarmPageBackground(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                widget.completed ? 'Completed lessons' : 'Pending lessons',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 7),
              Text(
                widget.completed
                    ? 'Choose a lesson to revisit it.'
                    : 'Choose a pattern to study. All levels are available.',
              ),
              const SizedBox(height: 15),
              LearningKeyboard(
                key: _searchTarget,
                hanzi: _search,
                enabled: true,
                hanziLabel: 'Search grammar',
                hanziHint: 'Chinese point, pattern or English explanation',
                hanziSuffixIcon: IconButton(
                  tooltip: 'Search grammar',
                  icon: const Icon(Icons.search),
                  onPressed: () => _refresh(resetPage: true),
                ),
                onHanziSubmitted: (_) => _refresh(resetPage: true),
              ),
              const SizedBox(height: 12),
              Wrap(
                key: _filtersTarget,
                spacing: 12,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<int>(
                      initialValue: _level ?? 0,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'HSK level'),
                      items: [
                        const DropdownMenuItem(
                          value: 0,
                          child: Text('All levels'),
                        ),
                        for (var level = 1; level <= 7; level++)
                          DropdownMenuItem(
                            value: level,
                            child: Text('HSK $level'),
                          ),
                      ],
                      onChanged: (value) {
                        _level = value == 0 ? null : value;
                        _refresh(resetPage: true);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: FutureBuilder<List<String>>(
                      future: _categories,
                      builder: (context, snapshot) =>
                          DropdownButtonFormField<String>(
                            initialValue: _category ?? '',
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: '',
                                child: Text('All categories'),
                              ),
                              for (final name in snapshot.data ?? <String>[])
                                DropdownMenuItem(
                                  value: name,
                                  child: Text(
                                    name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                            onChanged: snapshot.hasData
                                ? (value) {
                                    _category = value?.isEmpty == true
                                        ? null
                                        : value;
                                    _refresh(resetPage: true);
                                  }
                                : null,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FutureBuilder<GrammarPage>(
                future: _results,
                builder: (context, snapshot) {
                  if (!snapshot.hasData && !snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return TextButton(
                      onPressed: _refresh,
                      child: const Text('Could not load lessons. Try again.'),
                    );
                  }
                  final result = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${result.total} lessons',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (result.lessons.isEmpty)
                        const LearningCard(
                          child: Text('No lessons match these filters.'),
                        ),
                      for (final lesson in result.lessons)
                        Card(
                          child: ListTile(
                            key: ValueKey('grammar-lesson-${lesson.id}'),
                            title: Text(lesson.title),
                            subtitle: Text(
                              'HSK ${lesson.level} · ${lesson.category}'
                              '${lesson.pattern.isEmpty ? '' : '\n${lesson.pattern}'}',
                            ),
                            isThreeLine: lesson.pattern.isNotEmpty,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => GrammarLessonScreen(
                                    profileId: widget.profileId,
                                    lessonId: lesson.id,
                                    showPinyin: widget.showPinyin,
                                  ),
                                ),
                              );
                              if (mounted) _refresh();
                            },
                          ),
                        ),
                      if (result.total > 20)
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 8,
                          children: [
                            TextButton(
                              onPressed: _page == 0
                                  ? null
                                  : () {
                                      _page--;
                                      _refresh();
                                    },
                              child: const Text('Previous 20'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'Page ${_page + 1} of '
                                '${(result.total + 19) ~/ 20}',
                              ),
                            ),
                            TextButton(
                              onPressed: (_page + 1) * 20 >= result.total
                                  ? null
                                  : () {
                                      _page++;
                                      _refresh();
                                    },
                              child: const Text('Next 20'),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              const Text(
                'Grammar syllabus: Gushi, CC BY-SA 4.0. Some lessons include attributed AllSet Learning Chinese Grammar Wiki examples.',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class GrammarLessonScreen extends ConsumerStatefulWidget {
  const GrammarLessonScreen({
    required this.profileId,
    required this.lessonId,
    required this.showPinyin,
    super.key,
  });
  final int profileId;
  final String lessonId;
  final bool showPinyin;
  @override
  ConsumerState<GrammarLessonScreen> createState() =>
      _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends ConsumerState<GrammarLessonScreen> {
  final _explanationTarget = GlobalKey();
  final _completeTarget = GlobalKey();
  late Future<GrammarLesson?> _lesson;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _lesson = ref
        .read(grammarRepositoryProvider)
        .detail(widget.profileId, widget.lessonId);
  }

  Future<void> _setCompleted(bool completed) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(grammarRepositoryProvider)
          .setCompleted(widget.profileId, widget.lessonId, completed);
      if (!mounted) return;
      ref.invalidate(grammarCountsProvider(widget.profileId));
      setState(() {
        _saving = false;
        _lesson = ref
            .read(grammarRepositoryProvider)
            .detail(widget.profileId, widget.lessonId);
      });
    } catch (_) {
      if (mounted)
        setState(() {
          _saving = false;
          _error = 'Could not save your lesson. Try again.';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final audio = ref.watch(sentenceAudioSessionProvider);
    return Scaffold(
      appBar: AppBar(
        title: const AppScreenTitle('Grammar lesson'),
        actions: [
          IconButton(
            tooltip: 'Page tutorial',
            onPressed: () => showContextTour(context, [
              TourStop(
                _explanationTarget,
                'Understand the pattern',
                'Read the explanation and structure, then use the examples below to see it in context.',
              ),
              TourStop(
                _completeTarget,
                'Save your progress',
                'Mark the lesson complete when you understand it. You can reopen or move it back to Pending later.',
              ),
            ]),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: FutureBuilder<GrammarLesson?>(
              future: _lesson,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return const Center(child: CircularProgressIndicator());
                final lesson = snapshot.data;
                if (snapshot.hasError || lesson == null)
                  return Center(
                    child: TextButton(
                      onPressed: () => setState(() {
                        _lesson = ref
                            .read(grammarRepositoryProvider)
                            .detail(widget.profileId, widget.lessonId);
                      }),
                      child: const Text('Lesson unavailable. Try again.'),
                    ),
                  );
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'HSK ${lesson.level} · ${lesson.category} · '
                      '${lesson.completed ? 'Completed' : 'Pending'}',
                    ),
                    const SizedBox(height: 18),
                    LearningCard(
                      key: _explanationTarget,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What it means',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(lesson.explanation),
                          if (lesson.pattern.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            Text(
                              'Structure',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            SelectableText(lesson.pattern),
                          ],
                          if (lesson.allsetNote?.isNotEmpty == true) ...[
                            const SizedBox(height: 18),
                            Text(
                              'More on this pattern',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(lesson.allsetNote!),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Examples',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0; i < lesson.examples.length; i++)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.examples[i].chinese,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              if (widget.showPinyin &&
                                  lesson.examples[i].pinyin.isNotEmpty)
                                Text(lesson.examples[i].pinyin),
                              const SizedBox(height: 5),
                              Text(lesson.examples[i].english),
                              const SizedBox(height: 8),
                              SpeechAudioControls(
                                session: audio,
                                id: 'grammar-${lesson.id}-$i',
                                text: lesson.examples[i].chinese,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    KeyedSubtree(
                      key: _completeTarget,
                      child: FilledButton.icon(
                        key: const ValueKey('grammar-complete-action'),
                        onPressed: _saving
                            ? null
                            : () => _setCompleted(!lesson.completed),
                        icon: Icon(lesson.completed ? Icons.undo : Icons.check),
                        label: Text(
                          _saving
                              ? 'Saving…'
                              : lesson.completed
                              ? 'Move back to Pending'
                              : 'Mark lesson completed',
                        ),
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _error!,
                          key: const ValueKey('grammar-save-error'),
                        ),
                      ),
                    const SizedBox(height: 22),
                    const Text(
                      'Grammar syllabus and first example: Gushi · CC BY-SA 4.0',
                    ),
                    const SelectableText(
                      'https://gushichinese.com/hsk-3.0/downloads',
                    ),
                    if (lesson.allsetUrl != null) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'AllSet Learning Chinese Grammar Wiki · CC BY-NC-SA 3.0',
                      ),
                      Text(lesson.allsetTitle ?? ''),
                      SelectableText(lesson.allsetUrl!),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
