import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'learning_providers.dart';
import 'quiz_screen.dart';

class WordQuizEntry extends ConsumerWidget {
  const WordQuizEntry({
    required this.profileId,
    required this.wordId,
    super.key,
  });
  final int profileId;
  final String wordId;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(learningProgressProvider(profileId))
      .when(
        loading: () => const LinearProgressIndicator(),
        error: (_, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Could not load your review state. Saved data has not been reset.',
            ),
            TextButton(
              onPressed: () =>
                  ref.invalidate(learningProgressProvider(profileId)),
              child: const Text('Try again'),
            ),
          ],
        ),
        data: (words) {
          final existing = words.where((p) => p.wordId == wordId).firstOrNull;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                existing == null
                    ? 'Ready to try two short recognition checks?'
                    : 'This word is in your review list. Vocabulary Practice shows when it is due.',
              ),
              const SizedBox(height: 12),
              if (existing == null)
                FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QuizScreen(
                        profileId: profileId,
                        wordId: wordId,
                        review: false,
                      ),
                    ),
                  ),
                  child: const Text('Continue to Quiz'),
                ),
            ],
          );
        },
      );
}
