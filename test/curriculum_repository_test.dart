import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/review/sqlite_learning_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/curriculum_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/content_pack.dart';

import 'curriculum_fixture.dart';
import 'pilot_fixture.dart';

class _V4 extends AppDatabase {
  _V4(super.executor);
  @override
  int get schemaVersion => 4;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) async {
      final schema = jsonDecode(
        File('docs/schema/drift_schema_v4.json').readAsStringSync(),
      );
      for (final entity in schema['fixed_sql']) {
        for (final sql in entity['sql']) {
          if (sql['dialect'] == 'sqlite') await customStatement(sql['sql']);
        }
      }
    },
  );
}

void main() {
  test('all words have linked valid questions, source examples and correctly joined audio', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = fullCurriculum(db);
    await repo.ready();
    await repo.ready();
    final words = await db.select(db.curriculumWords).get();
    expect(words, hasLength(11147));
    expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    final questions = await db.select(db.curriculumQuestions).get();
    expect(questions, hasLength(85118));
    final byWord = <String, List<Map<String, dynamic>>>{};
    for (final q in questions) {
      byWord.putIfAbsent(q.wordId, () => []).add(jsonDecode(q.payloadJson));
    }
    final examples = <String, List<Map<String, dynamic>>>{};
    final joinedExamples = await db.customSelect('''
      SELECT e.word_id,s.payload_json,a.payload_json AS audio_json
      FROM curriculum_examples e JOIN curriculum_sentences s ON s.id=e.sentence_id
      LEFT JOIN curriculum_audio a ON a.sentence_id=s.id AND a.local_available=1
      ORDER BY e.word_id,e.position
    ''').get();
    for (final row in joinedExamples) {
      examples.putIfAbsent(row.read<String>('word_id'), () => []).add({
        ...jsonDecode(row.read<String>('payload_json')) as Map<String, dynamic>,
        if (row.readNullable<String>('audio_json') case final audio?)
          'audio': jsonDecode(audio),
      });
    }
    for (final row in words) {
      // Validate every complete lesson using the same linked payloads as runtime.
      final metadata = jsonDecode(row.metadataJson) as Map<String, dynamic>;
      metadata['examples'] = examples[row.id] ?? [];
      metadata['questions'] = byWord[row.id];
      final pack = VocabularyPack.parse(
        jsonEncode({
          'schemaVersion': row.contentSchema,
          'id': row.packId,
          'revision': row.revision,
          'words': [metadata],
        }),
      );
      expect(pack.entries.single.questions.length, greaterThanOrEqualTo(7));
    }
    for (final id in [
      words.first.id,
      words.last.id,
      'starter.greeting.nihao.1',
    ]) {
      final lesson = await repo.lesson(id);
      expect(lesson, isNotNull);
    }
    final orphanAudio = await db.customSelect(
      '''SELECT a.id FROM curriculum_audio a LEFT JOIN curriculum_sentences s ON s.id=a.sentence_id WHERE s.id IS NULL''',
    ).get();
    expect(orphanAudio, isEmpty);
    final joined = await db.customSelect(
      '''SELECT e.word_id FROM curriculum_examples e JOIN curriculum_audio a ON a.sentence_id=e.sentence_id WHERE a.local_available=1 LIMIT 1''',
    ).getSingle();
    final lesson = await repo.lesson(joined.read<String>('word_id'));
    expect(lesson!.entry.examples.any((e) => e.audio != null), isTrue);
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('20-row pages, profile order, moves, reset, rollback and learning advanced words', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final profiles = SqliteProfileRepository(db);
    final first = (await profiles.create(const ProfileDraft(name: 'First')))
        .selected!
        .id;
    final second = (await profiles.create(const ProfileDraft(name: 'Second')))
        .selected!
        .id;
    final repo = fullCurriculum(db);
    final page = await repo.page(first);
    final more = await repo.page(first, offset: 20);
    expect(page.words, hasLength(20));
    expect(page.hasMore, isTrue);
    expect(more.words, hasLength(20));
    expect({
      ...page.words.map((w) => w.id),
      ...more.words.map((w) => w.id),
    }, hasLength(40));
    final selected = more.words.last.id;
    await repo.move(first, selected, 'front');
    expect((await repo.page(first)).words.first.id, selected);
    expect((await repo.page(second)).words.first.id, page.words.first.id);
    await repo.move(first, selected, 'down');
    expect((await repo.page(first)).words[1].id, selected);
    await repo.move(first, selected, 'up');
    expect((await repo.page(first)).words.first.id, selected);
    await db.customStatement(
      "CREATE TRIGGER fail_queue BEFORE UPDATE ON learning_queue BEGIN SELECT RAISE(ABORT,'test failure'); END",
    );
    await expectLater(repo.move(first, selected, 'down'), throwsA(anything));
    expect((await repo.page(first)).words.first.id, selected);
    await db.customStatement('DROP TRIGGER fail_queue');
    await repo.reset(first);
    expect((await repo.page(first)).words.first.id, page.words.first.id);
    final last =
        (await db
                .customSelect(
                  'SELECT id FROM curriculum_words ORDER BY default_position DESC LIMIT 1',
                )
                .getSingle())
            .read<String>('id');
    final learning = SqliteLearningRepository(
      db,
      catalogue: () async => [],
      lookup: repo.lesson,
    );
    final quiz = await learning.begin(first, last, review: false);
    await learning.submit(quiz, {
      for (final q in quiz.word.entry.questions)
        q.id: q.isTyped ? q.correctAnswer : q.correctOptionId,
    });
    expect(await learning.progress(first), hasLength(1));
    final remaining = await db
        .customSelect(
          'SELECT count(*) AS n FROM learning_queue q WHERE profile_id=? AND NOT EXISTS(SELECT 1 FROM vocabulary_progress p WHERE p.profile_id=q.profile_id AND p.word_id=q.word_id)',
          variables: [Variable(first)],
        )
        .getSingle();
    expect(remaining.read<int>('n'), 11146);
    expect(
      await repo.page(first, search: "' OR 1=1 --").then((p) => p.words),
      isEmpty,
    );
    await expectLater(repo.move(999, selected, 'front'), throwsStateError);
  });

  test('v4 migration, queue restart and curriculum revision preserve attempts and backup', () async {
    final dir = await Directory.systemTemp.createTemp('nihao-queue-test-');
    final file = File('${dir.path}/learner.sqlite');
    AppDatabase db = _V4(NativeDatabase(file));
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Existing'))).selected!.id;
    final old = loadPilot();
    final learning = SqliteLearningRepository(db, catalogue: () async => [old]);
    final attempt = await learning.begin(profile, old.entry.id, review: false);
    await learning.submit(attempt, correctAnswers(old));
    final before = (await db.select(db.vocabularyAttempts).get()).single
        .toJson();
    await db.close();
    final backup = await file.copy('${dir.path}/backup.sqlite');
    db = AppDatabase(NativeDatabase(file));
    var repo = fullCurriculum(db);
    final page = await repo.page(profile);
    expect(page.words.any((w) => w.id == old.entry.id), isFalse);
    await repo.move(profile, page.words[5].id, 'front');
    await db.close();
    db = AppDatabase(NativeDatabase(file));
    repo = fullCurriculum(db);
    expect((await repo.page(profile)).words.first.id, page.words[5].id);
    expect(
      (await db.select(db.vocabularyAttempts).get()).single.toJson(),
      before,
    );
    final manifest = jsonDecode(
      File('assets/content/curriculum.manifest.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final updated = CurriculumRepository(
      db,
      seedFile: File('assets/content/curriculum.sqlite'),
      manifest: {...manifest, 'revision': (manifest['revision'] as int) + 1},
    );
    await updated.ready();
    expect((await updated.page(profile)).words.first.id, page.words[5].id);
    expect(
      (await db.select(db.vocabularyAttempts).get()).single.toJson(),
      before,
    );
    await db.close();
    final restored = _V4(NativeDatabase(backup));
    expect(
      (await restored.select(restored.vocabularyAttempts).get()).single
          .toJson(),
      before,
    );
    await restored.close();
    await dir.delete(recursive: true);
  });

  test(
    'bad seed checksum leaves learner records and install marker intact',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await SqliteProfileRepository(db)
          .create(const ProfileDraft(name: 'Keep'));
      final repo = CurriculumRepository(
        db,
        seedFile: File('assets/content/curriculum.sqlite'),
        manifest: {'revision': 1, 'sha256': '0' * 64},
      );
      await expectLater(repo.ready(), throwsFormatException);
      expect(await db.select(db.curriculumWords).get(), isEmpty);
      expect(await db.select(db.curriculumInstalls).get(), isEmpty);
      expect(await db.select(db.profiles).get(), hasLength(1));
    },
  );

  test('failed curriculum writes roll back and can be retried', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await SqliteProfileRepository(db).create(const ProfileDraft(name: 'Keep'));
    await db.customStatement(
      "CREATE TRIGGER fail_questions BEFORE INSERT ON curriculum_questions BEGIN SELECT RAISE(ABORT, 'test failure'); END",
    );
    final repo = fullCurriculum(db);
    await expectLater(repo.ready(), throwsA(isA<Exception>()));
    expect(await db.select(db.curriculumWords).get(), isEmpty);
    expect(await db.select(db.curriculumSentences).get(), isEmpty);
    expect(await db.select(db.curriculumInstalls).get(), isEmpty);
    expect(await db.select(db.profiles).get(), hasLength(1));
    await db.customStatement('DROP TRIGGER fail_questions');
    await repo.ready();
    expect(
      (await db
              .customSelect('SELECT count(*) AS n FROM curriculum_words')
              .getSingle())
          .read<int>('n'),
      11147,
    );
  });
}
