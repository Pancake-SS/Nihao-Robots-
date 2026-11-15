import 'dart:async';

import 'package:flutter/material.dart';

import '../../shared/app_brand.dart';

import '../../app/theme.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/robot_art.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../vocabulary/vocabulary_repository.dart';
import 'learning_providers.dart';
import 'quiz_screen.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({required this.profileId, super.key});
  final int profileId;
  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen>
    with WidgetsBindingObserver {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      ref.invalidate(learningProgressProvider(widget.profileId));
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogue = ref.watch(vocabularyCatalogueProvider);
    final progress = ref.watch(learningProgressProvider(widget.profileId));
    final now = ref.read(learningClockProvider)().toUtc();
    return Scaffold(
      appBar: AppBar(
        title: const AppScreenTitle('Vocabulary Practice'),
        actions: [
          IconButton(
            tooltip: 'Refresh reviews',
            onPressed: () {
              ref.invalidate(vocabularyCatalogueProvider);
              ref.invalidate(learningProgressProvider(widget.profileId));
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: progress.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text(
                    'Could not load your reviews. Your saved data has not been reset.',
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(
                      learningProgressProvider(widget.profileId),
                    ),
                    child: const Text('Try again'),
                  ),
                ],
              ),
              data: (words) => ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SunnyHero(
                    title: 'Practice',
                    subtitle: 'Remember a little more with every review.',
                    tag: 'Your saved vocabulary schedule',
                    robot: RobotArtwork.orbOnPaper,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${words.where((p) => p.isDue(now)).length} due · ${words.length} in early learning',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Early reviews practise word recognition and recall. They do not award mastery.',
                  ),
                  if (words.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        'No reviews yet. Browse words, explore a lesson, then take its first quiz.',
                      ),
                    ),
                  if (catalogue.hasError)
                    TextButton(
                      onPressed: () =>
                          ref.invalidate(vocabularyCatalogueProvider),
                      child: const Text('Reload lesson content'),
                    ),
                  for (final progress in words)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Card(
                        elevation: 0,
                        color: AppColors.paper,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Builder(
                            builder: (context) {
                              final lesson = ref.watch(
                                vocabularyLessonProvider(progress.wordId),
                              );
                              final word = lesson.asData?.value;
                              final due = progress.dueAt.toLocal();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    word?.entry.hanzi ??
                                        'Lesson content unavailable',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  Text('Stage: ${progress.stage.name}'),
                                  Text(
                                    'Due: ${MaterialLocalizations.of(context).formatFullDate(due)}, '
                                    '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(due))}',
                                  ),
                                  Text(
                                    'Successful delayed reviews: ${progress.successfulReviews}',
                                  ),
                                  const SizedBox(height: 12),
                                  if (lesson.isLoading)
                                    const LinearProgressIndicator()
                                  else if (lesson.hasError)
                                    TextButton(
                                      onPressed: () => ref.invalidate(
                                        vocabularyLessonProvider(
                                          progress.wordId,
                                        ),
                                      ),
                                      child: const Text(
                                        'Reload lesson content',
                                      ),
                                    )
                                  else if (word == null)
                                    const Text(
                                      'Your progress is retained. Reload the lesson content to review it.',
                                    )
                                  else if (!progress.isDue(now))
                                    const Text('Not due yet')
                                  else
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder: (_) => QuizScreen(
                                                profileId: widget.profileId,
                                                wordId: progress.wordId,
                                                review: true,
                                              ),
                                            ),
                                          ),
                                      child: const Text('Review now'),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
