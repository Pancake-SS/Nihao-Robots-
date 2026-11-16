import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/app_database.dart';
import '../vocabulary/vocabulary_repository.dart';
import 'learning.dart';

class SqliteLearningRepository implements LearningRepository {
  SqliteLearningRepository(
    this.database, {
    required this.catalogue,
    this.lookup,
    DateTime Function()? now,
    String Function()? eventId,
  }) : now = now ?? DateTime.now,
       eventId = eventId ?? newAttemptId;
  final AppDatabase database;
  final Future<List<CatalogueWord>> Function() catalogue;
  final Future<CatalogueWord?> Function(String)? lookup;
  final DateTime Function() now;
  final String Function() eventId;

  Future<void> _profile(int id) async {
    if (await (database.select(
          database.profiles,
        )..where((p) => p.id.equals(id))).getSingleOrNull() ==
        null) {
      throw const LearningConflict('This profile is no longer available.');
    }
  }

  Future<CatalogueWord> _word(String id) async {
    if (lookup != null) {
      final word = await lookup!(id);
      if (word != null && word.entry.questions.isNotEmpty) return word;
      throw const LearningConflict(
        'This lesson is not currently available. Your saved history is retained.',
      );
    }
    for (final word in await catalogue()) {
      if (word.entry.id == id && word.entry.questions.isNotEmpty) return word;
    }
    throw const LearningConflict(
      'This lesson is not currently available. Your saved history is retained.',
    );
  }

  Future<VocabularyProgressData?> _row(int profileId, String wordId) =>
      (database.select(database.vocabularyProgress)..where(
            (p) => p.profileId.equals(profileId) & p.wordId.equals(wordId),
          ))
          .getSingleOrNull();

  Future<int> _versionBefore(
    int profileId,
    String wordId,
    VocabularyProgressData? row,
  ) async {
    if (row != null) return row.version;
    // A mastered word can return to Learn while immutable prior attempts stay.
    final history = await database
        .customSelect(
          'SELECT COALESCE(MAX(version_before) + 1, 0) AS next_version '
          'FROM vocabulary_attempts WHERE profile_id = ? AND word_id = ?',
          variables: [Variable.withInt(profileId), Variable.withString(wordId)],
        )
        .getSingle();
    return history.read<int>('next_version');
  }

  WordProgress _progress(VocabularyProgressData row, int correctCount) =>
      WordProgress(
        wordId: row.wordId,
        stage: LearningStage.values.byName(row.stage),
        dueAt: DateTime.fromMillisecondsSinceEpoch(row.dueAtMs, isUtc: true),
        version: row.version,
        successfulReviews: row.successfulReviews,
        correctCount: correctCount,
      );

  @override
  Future<List<WordProgress>> progress(int profileId) => database.transaction(
    () async {
      await _profile(profileId);
      final rows =
          await (database.select(database.vocabularyProgress)
                ..where((p) => p.profileId.equals(profileId))
                ..orderBy([(p) => OrderingTerm.asc(p.wordId)]))
              .get();
      final totals = database.schemaVersion < 6
          ? <QueryRow>[]
          : await database
                .customSelect(
                  'SELECT word_id, COUNT(*) AS points FROM practice_responses '
                  'WHERE profile_id = ? AND correct = 1 GROUP BY word_id',
                  variables: [Variable.withInt(profileId)],
                )
                .get();
      final points = {
        for (final total in totals)
          total.read<String>('word_id'): total.read<int>('points'),
      };
      return List.unmodifiable(
        rows.map((row) => _progress(row, points[row.wordId] ?? 0)),
      );
    },
  );

  void _available(VocabularyProgressData? row, bool review) {
    if (review) {
      if (row == null)
        throw const LearningConflict(
          'Read the lesson and take its first quiz before reviewing.',
        );
    } else if (row != null) {
      throw const LearningConflict(
        'This word has already been learned. Open Practice to try it again.',
      );
    }
  }

  @override
  Future<QuizSession> begin(
    int profileId,
    String wordId, {
    required bool review,
  }) async {
    final word = await _word(wordId);
    return database.transaction(() async {
      await _profile(profileId);
      final row = await _row(profileId, wordId);
      _available(row, review);
      return QuizSession(
        eventId: eventId(),
        profileId: profileId,
        word: word,
        versionBefore: await _versionBefore(profileId, wordId, row),
        isReview: review,
      );
    });
  }

  SavedAttempt _receipt(VocabularyAttempt row) => SavedAttempt(
    eventId: row.eventId,
    passed: row.passed,
    nextDueAt: DateTime.fromMillisecondsSinceEpoch(
      row.nextDueAtMs,
      isUtc: true,
    ),
    stage: LearningStage.values.byName(row.nextStage),
    answeredAt: DateTime.fromMillisecondsSinceEpoch(
      row.answeredAtMs,
      isUtc: true,
    ),
  );

  @override
  Future<SavedAttempt> submit(
    QuizSession session,
    Map<String, String> answers,
  ) async {
    if (!RegExp(r'^[a-f0-9]{32}$').hasMatch(session.eventId))
      throw ArgumentError('Invalid attempt identity.');
    // Freeze caller-owned answers before the first await; grading uses canonical
    // content, never a caller-supplied score or a mutable selection map.
    final frozen = Map<String, String>.of(answers);
    final sorted = frozen.keys.toList()..sort();
    final encoded = jsonEncode({for (final key in sorted) key: frozen[key]});
    if (encoded.length > 10000) throw ArgumentError('Invalid answers.');
    return database.transaction(() async {
      final previous = await (database.select(
        database.vocabularyAttempts,
      )..where((a) => a.eventId.equals(session.eventId))).getSingleOrNull();
      if (previous != null) {
        if (previous.profileId != session.profileId ||
            previous.wordId != session.word.entry.id ||
            previous.packId != session.word.packId ||
            previous.contentRevision != session.word.revision ||
            previous.versionBefore != session.versionBefore ||
            previous.isReview != session.isReview ||
            previous.answersJson != encoded) {
          throw const LearningConflict(
            'This attempt ID has already been used for another submission.',
          );
        }
        return _receipt(previous);
      }
      final word = await _word(session.word.entry.id);
      if (word.packId != session.word.packId ||
          word.revision != session.word.revision) {
        throw const LearningConflict(
          'This lesson changed. Reopen it before continuing.',
        );
      }
      final questions = word.entry.questions;
      if (frozen.length != questions.length ||
          questions.any((q) => !q.accepts(frozen[q.id]))) {
        throw ArgumentError('Answer every question using an available choice.');
      }
      await _profile(session.profileId);
      final row = await _row(session.profileId, word.entry.id);
      if (await _versionBefore(session.profileId, word.entry.id, row) !=
          session.versionBefore) {
        throw const LearningConflict(
          'Another attempt updated this word. Return to Practice and try again.',
        );
      }
      final time = now().toUtc();
      _available(row, session.isReview);
      final passed = questions.every((q) => q.isCorrect(frozen[q.id]));
      // Historical columns are required by schema 5. New quizzes have no
      // schedule or stage progression; their timestamp is retained for audit.
      final due = time;
      const stage = LearningStage.learning;
      final saved = await database
          .into(database.vocabularyAttempts)
          .insertReturning(
            VocabularyAttemptsCompanion.insert(
              eventId: session.eventId,
              profileId: session.profileId,
              wordId: word.entry.id,
              packId: word.packId,
              contentRevision: word.revision,
              versionBefore: session.versionBefore,
              isReview: session.isReview,
              answersJson: encoded,
              questionsJson: jsonEncode([
                for (final q in questions)
                  {
                    'id': q.id,
                    'kind': q.kind,
                    'prompt': q.prompt,
                    'options': q.options,
                    'correctOptionId': q.correctOptionId,
                    'explanation': q.explanation,
                  },
              ]),
              passed: passed,
              answeredAtMs: time.millisecondsSinceEpoch,
              nextDueAtMs: due.millisecondsSinceEpoch,
              nextStage: stage.name,
            ),
          );
      if (database.schemaVersion >= 6) {
        for (final question in questions) {
          await database
              .into(database.practiceResponses)
              .insert(
                PracticeResponsesCompanion.insert(
                  id: '${session.eventId}.${question.id}',
                  profileId: session.profileId,
                  wordId: word.entry.id,
                  questionId: question.id,
                  correct: question.isCorrect(frozen[question.id]),
                  answeredAtMs: time.millisecondsSinceEpoch,
                ),
              );
        }
      }
      await database
          .into(database.vocabularyProgress)
          .insertOnConflictUpdate(
            VocabularyProgressCompanion.insert(
              profileId: session.profileId,
              wordId: word.entry.id,
              stage: stage.name,
              dueAtMs: due.millisecondsSinceEpoch,
              version: session.versionBefore + 1,
              successfulReviews: row?.successfulReviews ?? 0,
            ),
          );
      return _receipt(saved);
    });
  }
}
