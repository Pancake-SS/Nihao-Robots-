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
    // Existing persisted review records, not a fabricated streak or a fluency score.
    final reviewHistory = ref.watch(learningProgressProvider(profile.id));
    final started = reviewHistory.asData?.value.length;

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
            const second = MetricCard(
              title: 'Daily streak',
              value: '—',
              caption: 'Daily activity tracking is coming soon',
              icon: Icons.local_fire_department_rounded,
              color: AppColors.peach,
              artwork: RobotArtwork.squareOnPaper,
            );
            return wide
                ? Row(
                    children: [
                      Expanded(child: first),
                      const SizedBox(width: 17),
                      const Expanded(child: second),
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
                title: 'This week',
                caption: 'A little practice goes a long way',
                icon: Icons.spa_outlined,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (final day in [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ])
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            day,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.mutedInk,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Container(
                            height: 29,
                            width: 29,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cream,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(
                              Icons.more_horiz,
                              size: 16,
                              color: AppColors.mutedInk,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Check-in history has not been implemented yet.',
                style: TextStyle(fontSize: 11, color: AppColors.mutedInk),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        LearningCard(
          key: progressKey,
          background: const Color(0xFFFCFEF7),
          child: JourneyProgress(count: started),
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
}
