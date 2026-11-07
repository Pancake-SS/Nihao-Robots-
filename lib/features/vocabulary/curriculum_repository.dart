import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import 'content_pack.dart';
import 'vocabulary_repository.dart';

String _curriculumDigest(Uint8List bytes) => sha256.convert(bytes).toString();

class QueueWord {
  const QueueWord(this.id, this.hanzi, this.pinyin, this.meaning);
  final String id, hanzi, pinyin, meaning;
}

class QueuePage {
  const QueuePage(this.words, this.hasMore);
  final List<QueueWord> words;
  final bool hasMore;
}

class CurriculumRepository {
  CurriculumRepository(
    this.database, {
    AssetBundle? bundle,
    this.seedFile,
    this.manifest,
  }) : bundle = bundle ?? rootBundle;
  final AppDatabase database;
  final AssetBundle bundle;
  final File? seedFile;
  final Map<String, dynamic>? manifest;
  Future<void>? _ready;

  Future<void> ready() =>
      _ready ??= _install().catchError((Object error, StackTrace stack) {
        _ready = null;
        Error.throwWithStackTrace(error, stack);
      });

  Future<void> _install() async {
    final metadata =
        manifest ??
        jsonDecode(
          await bundle.loadString('assets/content/curriculum.manifest.json'),
        ) as Map<String, dynamic>;
    final digest = metadata['sha256'], revision = metadata['revision'];
    if (digest is! String ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(digest) ||
        revision is! int ||
        revision < 1) {
      throw const FormatException('Invalid curriculum manifest.');
    }
    final installed = await database
        .select(database.curriculumInstalls)
        .getSingleOrNull();
    if (installed != null) {
      if (installed.revision > revision) return;
      if (installed.revision == revision) {
        if (installed.digest != digest)
          throw const FormatException('Curriculum changed without revision.');
        return;
      }
    }
    final bytes = seedFile != null
        ? await seedFile!.readAsBytes()
        : (await bundle.load('assets/content/curriculum.sqlite')).buffer
              .asUint8List();
    if (bytes.length > 150000000 ||
        await compute(_curriculumDigest, bytes) != digest) {
      throw const FormatException('Curriculum checksum mismatch.');
    }
    final directory = await Directory.systemTemp.createTemp(
      'nihao-curriculum-',
    );
    final file = File('${directory.path}/verified.sqlite');
    await file.writeAsBytes(bytes, flush: true);
    var attached = false;
    try {
      await database.transaction(() async {
        await database.customStatement('ATTACH DATABASE ? AS curriculum_seed', [
          file.path,
        ]);
        attached = true;
        final integrity = await database
            .customSelect('PRAGMA curriculum_seed.integrity_check')
            .get();
        if (integrity.length != 1 ||
            integrity.single.data.values.single != 'ok' ||
            (await database
                    .customSelect('PRAGMA curriculum_seed.foreign_key_check')
                    .get())
                .isNotEmpty) {
          throw const FormatException('Invalid curriculum database.');
        }
        // Insert parents first. Never delete words referenced by queues or history.
        await database.customStatement(
          '''INSERT INTO curriculum_words SELECT * FROM curriculum_seed.curriculum_words WHERE true
          ON CONFLICT(id) DO UPDATE SET pack_id=excluded.pack_id, revision=excluded.revision,
          content_schema=excluded.content_schema, hanzi=excluded.hanzi,pinyin=excluded.pinyin,meaning=excluded.meaning,
          search_text=excluded.search_text,default_position=excluded.default_position,metadata_json=excluded.metadata_json''',
        );
        await database.customStatement('''INSERT INTO curriculum_sentences SELECT * FROM curriculum_seed.curriculum_sentences WHERE true
          ON CONFLICT(id) DO UPDATE SET payload_json=excluded.payload_json''');
        for (final table in [
          'curriculum_examples',
          'curriculum_audio',
          'curriculum_questions',
        ]) {
          await database.customStatement('DELETE FROM $table');
          await database.customStatement(
            'INSERT INTO $table SELECT * FROM curriculum_seed.$table',
          );
        }
        if ((await database.customSelect('PRAGMA foreign_key_check').get())
            .isNotEmpty) {
          throw const FormatException('Curriculum links are inconsistent.');
        }
        await database
            .into(database.curriculumInstalls)
            .insertOnConflictUpdate(
              CurriculumInstallsCompanion.insert(
                id: const Value(1),
                revision: revision,
                digest: digest,
              ),
            );
      });
    } finally {
      if (attached)
        await database.customStatement('DETACH DATABASE curriculum_seed');
      await file.delete();
      await directory.delete();
    }
  }

  Future<CatalogueWord?> lesson(String id) async {
    await ready();
    final row = await (database.select(
      database.curriculumWords,
    )..where((w) => w.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final examples = await database
        .customSelect(
          '''
      SELECT s.payload_json, a.payload_json AS audio_json
      FROM curriculum_examples e JOIN curriculum_sentences s ON s.id=e.sentence_id
      LEFT JOIN curriculum_audio a ON a.sentence_id=s.id AND a.local_available=1
      WHERE e.word_id=? ORDER BY e.position
    ''',
          variables: [Variable(id)],
        )
        .get();
    final questions =
        await (database.select(database.curriculumQuestions)
              ..where((q) => q.wordId.equals(id))
              ..orderBy([(q) => OrderingTerm.asc(q.position)]))
            .get();
    final word = jsonDecode(row.metadataJson) as Map<String, dynamic>;
    word['examples'] = examples
        .map(
          (r) => <String, dynamic>{
            ...jsonDecode(r.read<String>('payload_json'))
                as Map<String, dynamic>,
            if (r.readNullable<String>('audio_json') case final audio?)
              'audio': jsonDecode(audio),
          },
        )
        .toList();
    word['questions'] = questions
        .map((q) => jsonDecode(q.payloadJson))
        .toList();
    final pack = VocabularyPack.parse(
      jsonEncode({
        'schemaVersion': row.contentSchema,
        'id': row.packId,
        'revision': row.revision,
        'words': [word],
      }),
    );
    return CatalogueWord(pack.id, pack.revision, pack.entries.single);
  }

  Future<void> _queue(int profile) async {
    await ready();
    await database.transaction(() async {
      if (await (database.select(
            database.profiles,
          )..where((p) => p.id.equals(profile))).getSingleOrNull() ==
          null) {
        throw StateError('Profile no longer exists.');
      }
      await database.customStatement(
        '''
        INSERT INTO learning_queue(profile_id,word_id,position)
        SELECT ?, w.id, COALESCE((SELECT max(position)+1 FROM learning_queue WHERE profile_id=?),0)
          + ROW_NUMBER() OVER(ORDER BY w.default_position,w.id)-1
        FROM curriculum_words w WHERE NOT EXISTS
          (SELECT 1 FROM learning_queue q WHERE q.profile_id=? AND q.word_id=w.id)
      ''',
        [profile, profile, profile],
      );
    });
  }

  Future<QueuePage> page(
    int profile, {
    int offset = 0,
    String search = '',
  }) async {
    if (offset < 0 || offset > 20000 || search.length > 100)
      throw ArgumentError('Invalid queue page.');
    await _queue(profile);
    final rows = await database
        .customSelect(
          '''
      SELECT w.id,w.hanzi,w.pinyin,w.meaning FROM learning_queue q
      JOIN curriculum_words w ON w.id=q.word_id
      WHERE q.profile_id=? AND instr(w.search_text,?)>0
      AND NOT EXISTS (SELECT 1 FROM vocabulary_progress p WHERE p.profile_id=q.profile_id AND p.word_id=q.word_id)
      ORDER BY q.position,q.word_id LIMIT 21 OFFSET ?
    ''',
          variables: [
            Variable(profile),
            Variable(search.trim().toLowerCase()),
            Variable(offset),
          ],
        )
        .get();
    return QueuePage(
      List.unmodifiable(
        rows
            .take(20)
            .map(
              (r) => QueueWord(
                r.read<String>('id'),
                r.read<String>('hanzi'),
                r.read<String>('pinyin'),
                r.read<String>('meaning'),
              ),
            ),
      ),
      rows.length > 20,
    );
  }

  Future<void> move(int profile, String id, String direction) async {
    if (!{'up', 'down', 'front'}.contains(direction))
      throw ArgumentError('Invalid move.');
    await _queue(profile);
    await database.transaction(() async {
      final row =
          await (database.select(database.learningQueue)..where(
                (q) => q.profileId.equals(profile) & q.wordId.equals(id),
              ))
              .getSingle();
      final comparison = direction == 'down' ? '>' : '<';
      final order = direction == 'up' ? 'DESC' : 'ASC';
      final neighbor = await database
          .customSelect(
            '''
        SELECT q.word_id,q.position FROM learning_queue q WHERE q.profile_id=? AND q.position $comparison ?
        AND NOT EXISTS(SELECT 1 FROM vocabulary_progress p WHERE p.profile_id=q.profile_id AND p.word_id=q.word_id)
        ORDER BY q.position $order LIMIT 1
      ''',
            variables: [Variable(profile), Variable(row.position)],
          )
          .getSingleOrNull();
      if (neighbor == null) return;
      final target = neighbor.read<int>('position');
      if (direction == 'front') {
        await database.customStatement(
          'UPDATE learning_queue SET position=position+1 WHERE profile_id=? AND position>=? AND position<?',
          [profile, target, row.position],
        );
      } else {
        await database.customStatement(
          'UPDATE learning_queue SET position=? WHERE profile_id=? AND word_id=?',
          [row.position, profile, neighbor.read<String>('word_id')],
        );
      }
      await database.customStatement(
        'UPDATE learning_queue SET position=? WHERE profile_id=? AND word_id=?',
        [target, profile, id],
      );
    });
  }

  Future<void> reset(int profile) async {
    await _queue(profile);
    await database.customStatement(
      '''UPDATE learning_queue SET position=
      (SELECT default_position FROM curriculum_words w WHERE w.id=learning_queue.word_id) WHERE profile_id=?''',
      [profile],
    );
  }
}

final curriculumRepositoryProvider = Provider<CurriculumRepository>(
  (ref) => CurriculumRepository(ref.watch(appDatabaseProvider)),
);
