import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../vocabulary/curriculum_repository.dart';
import '../vocabulary/vocabulary_repository.dart';

class MasterConflict implements Exception {
  const MasterConflict(this.message);
  final String message;
}

class MasterWord {
  const MasterWord(this.id, this.hanzi, this.pinyin, this.meaning);
  final String id, hanzi, pinyin, meaning;
}

class MasterRepository {
  MasterRepository(this.database, this.lookup, {this.ready});
  final AppDatabase database;
  final Future<CatalogueWord?> Function(String) lookup;
  final Future<void> Function()? ready;

  Future<Set<String>> masteredIds(int profileId) async {
    final rows = await (database.select(
      database.masteredWords,
    )..where((row) => row.profileId.equals(profileId))).get();
    return {for (final row in rows) row.wordId};
  }

  /// All shared words plus only this profile's custom words. Empty search
  /// shows the first twenty curriculum words for instant mastery.
  Future<List<MasterWord>> searchAll(int profileId, String query) async {
    await ready?.call();
    final term = query.trim().toLowerCase();
    if (term.length > 100) throw ArgumentError('Search is too long.');
    final rows = await database
        .customSelect(
          'WITH words AS ('
          'SELECT id, hanzi, pinyin, meaning, default_position FROM curriculum_words '
          "WHERE pack_id NOT LIKE 'custom.%' OR "
          "json_extract(metadata_json, '\$.ownerProfileId') = ? "
          'UNION ALL '
          'SELECT c.id, c.hanzi, c.pinyin, '
          "json_extract(c.metadata_json, '\$.meaning'), 1000000 + c.position "
          'FROM content_words c WHERE '
          "(c.pack_id NOT LIKE 'custom.%' OR "
          "json_extract(c.metadata_json, '\$.ownerProfileId') = ?) AND NOT EXISTS "
          '(SELECT 1 FROM curriculum_words w WHERE w.id = c.id)) '
          'SELECT id, hanzi, pinyin, meaning FROM words '
          'WHERE instr(lower(hanzi || \' \' || pinyin || \' \' || meaning), ?) > 0 '
          'ORDER BY CASE WHEN hanzi = ? OR lower(meaning) = ? THEN 0 ELSE 1 END, '
          'default_position, id LIMIT 20',
          variables: [
            Variable.withInt(profileId),
            Variable.withInt(profileId),
            Variable.withString(term),
            Variable.withString(query.trim()),
            Variable.withString(term),
          ],
        )
        .get();
    return [
      for (final row in rows)
        MasterWord(
          row.read<String>('id'),
          row.read<String>('hanzi'),
          row.read<String>('pinyin'),
          row.read<String>('meaning'),
        ),
    ];
  }

  /// Regular Master requires a passed full quiz in the UI and 25 points here.
  /// Instant Master is a confirmed direct promotion with neither requirement.
  /// Legacy writing rows stay in storage for old account saves.
  Future<void> completeTest({
    required int profileId,
    required String wordId,
    required bool instant,
  }) async {
    final word = await lookup(wordId);
    if (word == null || (!instant && word.entry.questions.isEmpty)) {
      throw const MasterConflict('This lesson is unavailable.');
    }
    await database.transaction(() async {
      final existing =
          await (database.select(database.masteredWords)..where(
                (row) =>
                    row.profileId.equals(profileId) & row.wordId.equals(wordId),
              ))
              .getSingleOrNull();
      if (existing != null) return;
      final profile = await (database.select(
        database.profiles,
      )..where((row) => row.id.equals(profileId))).getSingleOrNull();
      if (profile == null) {
        throw const MasterConflict('This profile is no longer available.');
      }
      if (!instant) {
        final score = await database
            .customSelect(
              'SELECT COUNT(*) AS points FROM practice_responses '
              'WHERE profile_id = ? AND word_id = ? AND correct = 1',
              variables: [
                Variable.withInt(profileId),
                Variable.withString(wordId),
              ],
            )
            .getSingle();
        if (score.read<int>('points') < 25) {
          throw const MasterConflict(
            'This word needs 25 correct answers first.',
          );
        }
      }
      final time = DateTime.now().toUtc().millisecondsSinceEpoch;
      final progress =
          await (database.select(database.vocabularyProgress)..where(
                (row) =>
                    row.profileId.equals(profileId) & row.wordId.equals(wordId),
              ))
              .getSingleOrNull();
      if (progress == null) {
        final version = await database
            .customSelect(
              'SELECT COALESCE(MAX(version_before) + 1, 1) AS version '
              'FROM vocabulary_attempts WHERE profile_id = ? AND word_id = ?',
              variables: [
                Variable.withInt(profileId),
                Variable.withString(wordId),
              ],
            )
            .getSingle();
        await database
            .into(database.vocabularyProgress)
            .insert(
              VocabularyProgressCompanion.insert(
                profileId: profileId,
                wordId: wordId,
                stage: 'learning',
                dueAtMs: time,
                version: version.read<int>('version'),
                successfulReviews: 0,
              ),
            );
      }
      await database
          .into(database.masteredWords)
          .insertOnConflictUpdate(
            MasteredWordsCompanion.insert(
              profileId: profileId,
              wordId: wordId,
              masteredAtMs: time,
            ),
          );
    });
  }

  /// Returning to Learn keeps immutable answers, correctness points and any
  /// legacy writing data. A later Learn quiz uses a new attempt version.
  Future<bool> returnToLearn(int profileId, String wordId) async {
    return database.transaction(() async {
      final removed =
          await (database.delete(database.masteredWords)..where(
                (row) =>
                    row.profileId.equals(profileId) & row.wordId.equals(wordId),
              ))
              .go();
      if (removed == 0) return false;
      await (database.delete(database.vocabularyProgress)..where(
            (row) =>
                row.profileId.equals(profileId) & row.wordId.equals(wordId),
          ))
          .go();
      final queued =
          await (database.select(database.learningQueue)..where(
                (row) =>
                    row.profileId.equals(profileId) & row.wordId.equals(wordId),
              ))
              .getSingleOrNull();
      if (queued != null) {
        await database.customStatement(
          'UPDATE learning_queue SET position = position + 1 WHERE profile_id = ?',
          [profileId],
        );
        await database.customStatement(
          'UPDATE learning_queue SET position = 0 WHERE profile_id = ? AND word_id = ?',
          [profileId, wordId],
        );
      } else {
        // Instant Master can happen before this profile has opened Learn.
        final curriculumWord = await (database.select(
          database.curriculumWords,
        )..where((row) => row.id.equals(wordId))).getSingleOrNull();
        if (curriculumWord != null) {
          await database.customStatement(
            'UPDATE learning_queue SET position = position + 1 WHERE profile_id = ?',
            [profileId],
          );
          await database.customStatement(
            'INSERT INTO learning_queue(profile_id,word_id,position) VALUES(?,?,0)',
            [profileId, wordId],
          );
        }
      }
      return true;
    });
  }
}

final masterRepositoryProvider = Provider<MasterRepository>((ref) {
  return MasterRepository(
    ref.watch(appDatabaseProvider),
    (id) => ref.read(vocabularyLessonProvider(id).future),
    ready: () => ref.read(curriculumRepositoryProvider).ready(),
  );
});

final masteredIdsProvider = FutureProvider.family<Set<String>, int>((ref, id) {
  return ref.watch(masterRepositoryProvider).masteredIds(id);
}, retry: (_, _) => null);
