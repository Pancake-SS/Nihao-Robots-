import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/app_database.dart';
import 'content_pack.dart';
import 'vocabulary_repository.dart';

/// Installs validated offline packs atomically, then reads lessons from SQLite.
/// Content updates never touch learner progress or attempt-history tables.
class SqliteVocabularyRepository implements VocabularyRepository {
  SqliteVocabularyRepository(this.database, this.bundled);
  final AppDatabase database;
  final BundledVocabularyRepository bundled;

  @override
  Future<List<CatalogueWord>> load() async {
    final incoming = await bundled.loadPacks();
    return database.transaction(() async {
      for (final pack in incoming) {
        await _install(pack);
      }
      final result = <CatalogueWord>[];
      for (final pack in incoming) {
        result.addAll(await _read(pack.id));
      }
      return List.unmodifiable(result);
    });
  }

  Future<void> _install(VocabularyPack pack) async {
    final canonical = jsonEncode(pack.toJson());
    final installed = await (database.select(
      database.contentPacks,
    )..where((p) => p.id.equals(pack.id))).getSingleOrNull();
    if (installed != null) {
      if (installed.revision > pack.revision)
        return; // Never silently downgrade.
      if (installed.revision == pack.revision) {
        if (installed.canonicalJson != canonical) {
          throw const FormatException(
            'Content changed without a new revision.',
          );
        }
        return;
      }
    }
    for (final entry in pack.entries) {
      final existing = await (database.select(
        database.contentWords,
      )..where((w) => w.id.equals(entry.id))).getSingleOrNull();
      if (existing != null && existing.packId != pack.id) {
        throw const FormatException(
          'A different pack owns this word identity.',
        );
      }
    }
    await database
        .into(database.contentPacks)
        .insertOnConflictUpdate(
          ContentPacksCompanion.insert(
            id: pack.id,
            revision: pack.revision,
            contentSchema: pack.schemaVersion,
            canonicalJson: canonical,
          ),
        );
    // Cascades apply only to the shared examples/exercises. Progress deliberately
    // references stable sense IDs without a cascading content foreign key.
    await (database.delete(
      database.contentWords,
    )..where((w) => w.packId.equals(pack.id))).go();
    for (var i = 0; i < pack.entries.length; i++) {
      final entry = pack.entries[i];
      final metadata = entry.toJson(pack.schemaVersion)
        ..remove('examples')
        ..remove('questions');
      await database
          .into(database.contentWords)
          .insert(
            ContentWordsCompanion.insert(
              id: entry.id,
              packId: pack.id,
              position: i,
              hanzi: entry.hanzi,
              pinyin: entry.pinyin,
              metadataJson: jsonEncode(metadata),
            ),
          );
      await database.batch((batch) {
        batch.insertAll(database.contentExamples, [
          for (var j = 0; j < entry.examples.length; j++)
            ContentExamplesCompanion.insert(
              wordId: entry.id,
              position: j,
              payloadJson: jsonEncode(
                entry.examples[j].toJson(pack.schemaVersion),
              ),
            ),
        ]);
        batch.insertAll(database.contentExercises, [
          for (var j = 0; j < entry.questions.length; j++)
            ContentExercisesCompanion.insert(
              wordId: entry.id,
              questionId: entry.questions[j].id,
              position: j,
              kind: entry.questions[j].kind,
              payloadJson: jsonEncode(entry.questions[j].toJson()),
            ),
        ]);
      });
    }
  }

  Future<List<CatalogueWord>> _read(String packId) async {
    final pack = await (database.select(
      database.contentPacks,
    )..where((p) => p.id.equals(packId))).getSingle();
    final words =
        await (database.select(database.contentWords)
              ..where((w) => w.packId.equals(packId))
              ..orderBy([(w) => OrderingTerm.asc(w.position)]))
            .get();
    final records = <Map<String, dynamic>>[];
    for (final word in words) {
      final examples =
          await (database.select(database.contentExamples)
                ..where((e) => e.wordId.equals(word.id))
                ..orderBy([(e) => OrderingTerm.asc(e.position)]))
              .get();
      final questions =
          await (database.select(database.contentExercises)
                ..where((q) => q.wordId.equals(word.id))
                ..orderBy([(q) => OrderingTerm.asc(q.position)]))
              .get();
      records.add({
        ...jsonDecode(word.metadataJson) as Map<String, dynamic>,
        'examples': examples.map((e) => jsonDecode(e.payloadJson)).toList(),
        if (pack.contentSchema >= 2)
          'questions': questions.map((q) => jsonDecode(q.payloadJson)).toList(),
      });
    }
    final restored = VocabularyPack.parse(
      jsonEncode({
        'schemaVersion': pack.contentSchema,
        'id': pack.id,
        'revision': pack.revision,
        'words': records,
      }),
    );
    if (jsonEncode(restored.toJson()) != pack.canonicalJson) {
      throw const FormatException('Installed lesson data is inconsistent.');
    }
    return restored.entries
        .map((entry) => CatalogueWord(pack.id, pack.revision, entry))
        .toList();
  }
}
