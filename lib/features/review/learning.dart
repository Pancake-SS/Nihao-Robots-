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
    this.correctCount = 0,
  });
  final String wordId;
  final LearningStage stage;
  final DateTime dueAt;
  final int version, successfulReviews;
  final int correctCount;
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
