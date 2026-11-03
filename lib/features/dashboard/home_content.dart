import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/learning_card.dart';
import '../../data/database_provider.dart';
import '../../shared/robot_art.dart';
import '../onboarding/foundation_repository.dart';
import '../onboarding/foundation_screen.dart';
import '../profiles/profile.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome, ${profile.name}!',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text('${profile.dailyMinutes} minutes a day · ${profile.goal.label}'),
        const SizedBox(height: 24),
        LearningCard(
          key: foundationKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: RobotArt(
                  artwork: RobotArtwork.trackedOnPaper,
                  size: 120,
                ),
              ),
              Text(
                'A small beginning',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const Text(
                'Meet your companions, then explore characters, Pinyin, tones and a first exchange.',
              ),
              const SizedBox(height: 16),
              foundation.when(
                loading: () => const LinearProgressIndicator(
                  semanticsLabel: 'Loading your place',
                ),
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
                          ? 'Introduction complete · replay any time'
                          : state.step == 0
                          ? 'Ready when you are'
                          : 'Resume at step ${state.step + 1} of $foundationStepCount',
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => FoundationScreen(
                            profile: profile,
                            initial: state,
                            replay: state.completed,
                          ),
                        ),
                      ),
                      child: Text(
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
          ),
        ),
        const SizedBox(height: 20),
        LearningCard(
          key: progressKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your learning journey',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              const Text(
                'Vocabulary lessons and reviews are coming next. Word totals, streaks and weekly activity will appear when learning records are available.',
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  for (final milestone in [500, 1000, 2000, 5000])
                    Chip(label: Text('$milestone words')),
                ],
              ),
              TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Word milestones'),
                    content: const SingleChildScrollView(
                      child: Text(
                        '500, 1,000, 2,000 and 5,000 words are product milestones, not fluency scores. '
                        'Future details will show the actual words behind your progress. '
                        'No vocabulary learning records are available in this version. '
                        'Reading the introduction does not count as learning or mastering a word.',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                child: const Text('View Details'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Starting level: ${profile.level.label}'),
        Text('Pinyin support: ${profile.showPinyin ? 'on' : 'off'}'),
      ],
    );
  }
}
