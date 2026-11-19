import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/dashboard_widgets.dart';
import '../../shared/learning_card.dart';
import '../../shared/robot_art.dart';
import '../../data/database_provider.dart';
import '../onboarding/foundation_repository.dart';
import '../onboarding/foundation_screen.dart';
import '../profiles/profile.dart';
import '../review/learning_providers.dart';
import '../review/master_repository.dart';
import 'daily_streak.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({
    required this.profile,
    required this.foundationKey,
    required this.progressKey,
    super.key,
  });
  final LearnerProfile profile;
  final GlobalKey foundationKey;
  final GlobalKey progressKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foundation = ref.watch(foundationStateProvider(profile.id));
    final reviewHistory = ref.watch(learningProgressProvider(profile.id));
    final started = reviewHistory.asData?.value.length;
    final mastered = ref
        .watch(masteredIdsProvider(profile.id))
        .asData
        ?.value
        .length;
    final streakState = ref.watch(dailyStreakProvider(profile.id));
    final streak = streakState.asData?.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SunnyHero(
          title: 'Home',
          subtitle: 'Small steps today, a more confident you tomorrow.',
          robot: RobotArtwork.trackedOnPaper,
          tag: 'Your Chinese learning journey',
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome, ${profile.name}!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text('${profile.dailyMinutes} minutes a day · ${profile.goal.label}'),
        const SizedBox(height: 19),
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 650;
            final first = MetricCard(
              title: 'Words started',
              value: started?.toString() ?? '—',
              caption: started == null
                  ? 'Reading your saved progress'
                  : 'With a saved learning quiz',
              icon: Icons.auto_stories_rounded,
              color: AppColors.yellow,
              artwork: RobotArtwork.orbOnPaper,
            );
            final second = MetricCard(
              title: 'Daily streak',
              value: streak?.count.toString() ?? '—',
              caption: streak == null
                  ? 'Reading activity history'
                  : streak.today.complete
                  ? 'All four daily goals complete today'
                  : 'Complete all four daily goals to grow your streak',
              icon: Icons.local_fire_department_rounded,
              color: AppColors.peach,
              artwork: RobotArtwork.squareOnPaper,
            );
            return wide
                ? Row(
                    children: [
                      Expanded(child: first),
                      const SizedBox(width: 17),
                      Expanded(child: second),
                    ],
                  )
                : Column(children: [first, const SizedBox(height: 14), second]);
          },
        ),
        const SizedBox(height: 18),
        LearningCard(
          background: const Color(0xFFFFFDF9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeading(
                title: 'Daily streak goals',
                caption: 'Finish all four goals on the same day',
                icon: Icons.spa_outlined,
              ),
              const SizedBox(height: 16),
              if (streakState.hasError)
                TextButton(
                  onPressed: () =>
                      ref.invalidate(dailyStreakProvider(profile.id)),
                  child: const Text('Could not load daily goals. Try again'),
                )
              else if (streak == null)
                const LinearProgressIndicator()
              else ...[
                _goal('New words', streak.today.newWords, 10),
                _goal('Quiz words', streak.today.quizWords, 20),
                _goal('Master reviews', streak.today.masteredWords, 10),
                _goal('Free writing', streak.today.writings, 1),
                const SizedBox(height: 8),
                const Text(
                  'Quiz words count once per word each day from lessons, Practice and Master tests.',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        LearningCard(
          key: progressKey,
          background: const Color(0xFFFCFEF7),
          child: JourneyProgress(count: mastered),
        ),
        const SizedBox(height: 18),
        LearningCard(
          key: foundationKey,
          background: const Color(0xFFFFF9ED),
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth > 510;
              final content = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading(
                    title: 'Start with the basics',
                    caption: 'Meet the robots and explore your first sounds',
                    icon: Icons.waving_hand_outlined,
                  ),
                  const SizedBox(height: 14),
                  foundation.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Could not load your introduction. Your saved data has not been reset.',
                        ),
                        TextButton(
                          onPressed: () {
                            ref.invalidate(appDatabaseProvider);
                            ref.invalidate(foundationStateProvider(profile.id));
                          },
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                    data: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.completed
                              ? 'Introduction complete · replay whenever you like'
                              : state.step == 0
                              ? 'Ready when you are'
                              : 'Resume at step ${state.step + 1} of $foundationStepCount',
                          style: const TextStyle(color: AppColors.mutedInk),
                        ),
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => FoundationScreen(
                                profile: profile,
                                initial: state,
                                replay: state.completed,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(
                            state.completed
                                ? 'Replay introduction'
                                : state.step == 0
                                ? 'Start introduction'
                                : 'Resume introduction',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
              return wide
                  ? Row(
                      children: [
                        Expanded(child: content),
                        const SizedBox(width: 14),
                        const RobotArt(
                          artwork: RobotArtwork.hoverOnPaper,
                          size: 128,
                        ),
                      ],
                    )
                  : content;
            },
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'LEARNING SETTINGS  •  ${profile.level.label.toUpperCase()}  •  '
          '${profile.dailyMinutes} MIN / DAY  •  PINYIN ${profile.showPinyin ? 'ON' : 'OFF'}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: .7,
            color: AppColors.mutedInk,
          ),
        ),
      ],
    );
  }

  Widget _goal(String title, int count, int target) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        Icon(
          count >= target ? Icons.check_circle : Icons.circle_outlined,
          color: count >= target ? const Color(0xFF3E9F62) : AppColors.mutedInk,
          size: 20,
        ),
        const SizedBox(width: 9),
        Expanded(child: Text(title)),
        Text(
          '$count / $target',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
