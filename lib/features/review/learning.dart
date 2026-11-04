import 'dart:math';

import '../vocabulary/vocabulary_repository.dart';

enum LearningStage { learning, review, relearning }

class WordProgress {
  const WordProgress({
    required this.wordId,
    required this.stage,
    required this.dueAt,
    required this.version,
    required this.successfulReviews,
  });
  final String wordId;
  final LearningStage stage;
  final DateTime dueAt;
  final int version, successfulReviews;
  bool isDue(DateTime now) => !dueAt.isAfter(now);
}

class QuizSession {
  const QuizSession({
    required this.eventId,
    required this.profileId,
    required this.word,
    required this.versionBefore,
    required this.isReview,
  });
  final String eventId;
  final int profileId, versionBefore;
  final CatalogueWord word;
  final bool isReview;
}

class SavedAttempt {
  const SavedAttempt({
    required this.eventId,
    required this.passed,
    required this.nextDueAt,
    required this.stage,
    required this.answeredAt,
  });
  final String eventId;
  final bool passed;
  final DateTime nextDueAt, answeredAt;
  final LearningStage stage;
}

class LearningConflict implements Exception {
  const LearningConflict(this.message);
  final String message;
}

/// Initial pilot intervals, not FSRS or a mastery rule. No score grants mastery.
class EarlyReviewPolicy {
  EarlyReviewPolicy({
    this.firstDelay = const Duration(minutes: 5),
    this.retryDelay = const Duration(minutes: 5),
    this.reviewDelay = const Duration(days: 1),
  }) {
    for (final delay in [firstDelay, retryDelay, reviewDelay]) {
      if (delay <= Duration.zero || delay > const Duration(days: 30)) {
        throw ArgumentError(
          'Review intervals must be positive and at most 30 days.',
        );
      }
    }
  }
  final Duration firstDelay, retryDelay, reviewDelay;
  Duration delay({required bool passed, required bool isReview}) => !passed
      ? retryDelay
      : isReview
      ? reviewDelay
      : firstDelay;
  LearningStage stage({required bool passed, required bool isReview}) => !passed
      ? LearningStage.relearning
      : isReview
      ? LearningStage.review
      : LearningStage.learning;
}

String newAttemptId() {
  final random = Random.secure();
  return List.generate(
    16,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}

abstract interface class LearningRepository {
  Future<List<WordProgress>> progress(int profileId);
  Future<QuizSession> begin(
    int profileId,
    String wordId, {
    required bool review,
  });
  Future<SavedAttempt> submit(QuizSession session, Map<String, String> answers);
}
