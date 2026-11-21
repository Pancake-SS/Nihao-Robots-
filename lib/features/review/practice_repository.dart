import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../vocabulary/vocabulary_repository.dart';
import 'learning.dart';

class RelearnWord {
  const RelearnWord(this.id, this.hanzi, this.pinyin, this.meaning);
  final String id, hanzi, pinyin, meaning;
}

class RelearnPage {
  const RelearnPage(this.words, this.hasMore);
  final List<RelearnWord> words;
  final bool hasMore;
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
    bool allowUnlearned = false,
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
      if (learned == null && !allowUnlearned) {
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
  Future<List<RelearnWord>> relearnSearch(
    int profileId,
    String query, {
    bool? mastered,
  }) async {
    if (query.trim().isEmpty) return const [];
    return (await browseLearned(
      profileId,
      query: query,
      mastered: mastered,
    )).words;
  }

  /// Browse learned words in small pages. Search uses Hanzi and English only,
  /// since Pinyin can identify several unrelated words.
  Future<RelearnPage> browseLearned(
    int profileId, {
    String query = '',
    bool? mastered,
    int offset = 0,
  }) async {
    final term = query.trim().toLowerCase();
    if (term.length > 500 || offset < 0 || offset > 20000) {
      throw ArgumentError('Invalid learned-word page.');
    }
    final rows = await database
        .customSelect(
          'WITH words AS ('
          'SELECT id, hanzi, pinyin, meaning, default_position FROM curriculum_words '
          'UNION ALL '
          'SELECT c.id, c.hanzi, c.pinyin, json_extract(c.metadata_json, \'\$.meaning\'), '
          '1000000 + c.position '
          'FROM content_words c WHERE NOT EXISTS '
          '(SELECT 1 FROM curriculum_words w WHERE w.id = c.id)) '
          'SELECT w.id, w.hanzi, w.pinyin, w.meaning FROM words w '
          'JOIN vocabulary_progress p ON p.word_id = w.id '
          'LEFT JOIN learning_queue q ON q.profile_id = p.profile_id AND q.word_id = w.id '
          'WHERE p.profile_id = ? AND '
          "instr(lower(w.hanzi || ' ' || COALESCE(w.meaning,'')), ?) > 0 "
          '${mastered == null
              ? ''
              : mastered
              ? 'AND EXISTS (SELECT 1 FROM mastered_words m WHERE m.profile_id = p.profile_id AND m.word_id = w.id) '
              : 'AND NOT EXISTS (SELECT 1 FROM mastered_words m WHERE m.profile_id = p.profile_id AND m.word_id = w.id) '}'
          'ORDER BY CASE WHEN w.hanzi = ? OR lower(w.meaning) = ? THEN 0 ELSE 1 END, '
          'COALESCE(q.position, w.default_position), w.id LIMIT 21 OFFSET ?',
          variables: [
            Variable.withInt(profileId),
            Variable.withString(term),
            Variable.withString(query.trim()),
            Variable.withString(term),
            Variable.withInt(offset),
          ],
        )
        .get();
    return RelearnPage([
      for (final row in rows.take(20))
        RelearnWord(
          row.read<String>('id'),
          row.read<String>('hanzi'),
          row.read<String>('pinyin'),
          row.read<String>('meaning'),
        ),
    ], rows.length > 20);
  }
}

final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  return PracticeRepository(
    ref.watch(appDatabaseProvider),
    (id) => ref.read(vocabularyLessonProvider(id).future),
  );
});
