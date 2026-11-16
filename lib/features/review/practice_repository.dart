import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../vocabulary/vocabulary_repository.dart';
import 'learning.dart';

class RelearnWord {
  const RelearnWord(this.id, this.hanzi, this.meaning);
  final String id, hanzi, meaning;
}

class PracticeRepository {
  PracticeRepository(this.database, this.lookup);
  final AppDatabase database;
  final Future<CatalogueWord?> Function(String) lookup;

  /// Record one first response. Repeating a missed question does not add a
  /// point, because the retry is not a new randomly selected question.
  Future<bool> recordFirstResponse({
    required String eventId,
    required int profileId,
    required String wordId,
    required String questionId,
    required String answer,
  }) async {
    final word = await lookup(wordId);
    final question = word?.entry.questions
        .where((question) => question.id == questionId)
        .firstOrNull;
    if (question == null || !question.accepts(answer)) {
      throw const LearningConflict('This question is no longer available.');
    }
    return database.transaction(() async {
      final existing = await (database.select(
        database.practiceResponses,
      )..where((response) => response.id.equals(eventId))).getSingleOrNull();
      if (existing != null) {
        if (existing.profileId != profileId ||
            existing.wordId != wordId ||
            existing.questionId != questionId) {
          throw const LearningConflict(
            'This response was already saved elsewhere.',
          );
        }
        return existing.correct;
      }
      final learned =
          await (database.select(database.vocabularyProgress)..where(
                (p) => p.profileId.equals(profileId) & p.wordId.equals(wordId),
              ))
              .getSingleOrNull();
      if (learned == null) {
        throw const LearningConflict('Learn this word before practising it.');
      }
      final correct = question.isCorrect(answer);
      await database
          .into(database.practiceResponses)
          .insert(
            PracticeResponsesCompanion.insert(
              id: eventId,
              profileId: profileId,
              wordId: wordId,
              questionId: questionId,
              correct: correct,
              answeredAtMs: DateTime.now().toUtc().millisecondsSinceEpoch,
            ),
          );
      return correct;
    });
  }

  /// Search only Hanzi and English meaning, so overlapping Pinyin cannot
  /// accidentally lead to a different lesson.
  Future<List<RelearnWord>> relearnSearch(int profileId, String query) async {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return const [];
    final rows = await database
        .customSelect(
          'WITH words AS ('
          'SELECT id, hanzi, meaning FROM curriculum_words '
          'UNION ALL '
          'SELECT c.id, c.hanzi, json_extract(c.metadata_json, \'\$.meaning\') '
          'FROM content_words c WHERE NOT EXISTS '
          '(SELECT 1 FROM curriculum_words w WHERE w.id = c.id)) '
          'SELECT w.id, w.hanzi, w.meaning FROM words w '
          'JOIN vocabulary_progress p ON p.word_id = w.id '
          'WHERE p.profile_id = ? AND '
          '(w.hanzi LIKE ? OR lower(w.meaning) LIKE ?) '
          'ORDER BY CASE WHEN w.hanzi = ? OR lower(w.meaning) = ? THEN 0 ELSE 1 END, '
          'w.id LIMIT 20',
          variables: [
            Variable.withInt(profileId),
            Variable.withString('%$term%'),
            Variable.withString('%$term%'),
            Variable.withString(query.trim()),
            Variable.withString(term),
          ],
        )
        .get();
    return [
      for (final row in rows)
        RelearnWord(
          row.read<String>('id'),
          row.read<String>('hanzi'),
          row.read<String>('meaning'),
        ),
    ];
  }
}

final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  return PracticeRepository(
    ref.watch(appDatabaseProvider),
    (id) => ref.read(vocabularyLessonProvider(id).future),
  );
});
