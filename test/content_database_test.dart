import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/review/sqlite_learning_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/content_pack.dart';
import 'package:ni_hao_robot/features/vocabulary/sqlite_vocabulary_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';

import 'imported_fixture.dart';
import 'pilot_fixture.dart';

class _V3 extends AppDatabase {
  _V3(super.executor);
  @override
  int get schemaVersion => 3;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) async {
      final schema = jsonDecode(
        File('docs/schema/drift_schema_v3.json').readAsStringSync(),
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
  test('published sources have five attributed examples and eight varied exercises per word', () {
    for (final path in starterPaths) {
      final pack = VocabularyPack.parse(File(path).readAsStringSync());
      expect(
        VocabularyPack.parse(jsonEncode(pack.toJson())).toJson(),
        pack.toJson(),
      );
      for (final word in pack.entries) {
        expect(word.examples, hasLength(5));
        expect(word.questions, hasLength(8));
        expect(word.questions.map((q) => q.kind).toSet(), {
          'meaning',
          'hanzi',
          'pinyin',
          'pinyin_hanzi',
          'meaning_pinyin',
          'pinyin_meaning',
          'cloze',
          'typed_hanzi',
        });
        expect(word.details!.sourceId, isNotEmpty);
        expect(
          word.examples.every(
            (e) => e.sourceId != null && e.sourceUrl!.startsWith('https://'),
          ),
          isTrue,
        );
        final typed = word.questions.last;
        expect(typed.isTyped, isTrue);
        expect(typed.isCorrect(' ${word.hanzi} '), isTrue);
        expect(typed.isCorrect('wrong'), isFalse);
        expect(typed.accepts('   '), isFalse);
        expect(typed.accepts('a' * 101), isFalse);
      }
    }
  });

  test('schema 3 rejects absent Pinyin directions, invalid metadata and unsupported question modes', () {
    for (final mutate in <void Function(Map<String, dynamic>)>[
      (p) => p['words'][0]['questions'].removeAt(2),
      (p) => p['words'][0]['questions'][2]['kind'] = 'audio',
      (p) => p['words'][0]['details']['sourceUrl'] = 'file:///secret',
      (p) => p['words'][0]['details']['band'] = 99,
      (p) => p['words'][0]['questions'].last['options'].add({
        'id': 'extra',
        'text': 'other',
      }),
      (p) => p['words'][0]['questions'].last['id'] =
          p['words'][0]['questions'][0]['id'],
      (p) => p['words'][0]['examples'][0]['sourceId'] = '../escape',
    ]) {
      final data = jsonDecode(
        File(starterPaths.last).readAsStringSync(),
      ) as Map<String, dynamic>;
      mutate(data);
      expect(
        () => VocabularyPack.parse(jsonEncode(data)),
        throwsFormatException,
      );
    }
  });

  test('content installs idempotently, rejects same-revision mutation and rolls back failed upgrades', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final bundle = ContentTestBundle();
    final repo = SqliteVocabularyRepository(
      db,
      BundledVocabularyRepository(bundle, starterPaths),
    );
    final words = await repo.load();
    expect(words, hasLength(21));
    await repo.load();
    expect(await db.select(db.contentWords).get(), hasLength(21));
    expect(await db.select(db.contentExamples).get(), hasLength(105));
    expect(await db.select(db.contentExercises).get(), hasLength(168));
    final original = bundle.files[starterPaths.last]!;
    final changed = jsonDecode(original) as Map<String, dynamic>;
    changed['words'][0]['meaning'] = 'Updated teaching gloss';
    bundle.files[starterPaths.last] = jsonEncode(changed);
    await expectLater(repo.load(), throwsFormatException);
    expect((await db.select(db.contentPacks).get()).last.revision, 2);
    changed['revision'] = 3;
    bundle.files[starterPaths.last] = jsonEncode(changed);
    await db.customStatement(
      "CREATE TRIGGER fail_content BEFORE INSERT ON content_exercises BEGIN SELECT RAISE(ABORT, 'test failure'); END",
    );
    await expectLater(repo.load(), throwsA(anything));
    expect(await db.select(db.contentWords).get(), hasLength(21));
    expect(await db.select(db.contentExercises).get(), hasLength(168));
    expect((await db.select(db.contentPacks).get()).last.revision, 2);
    await db.customStatement('DROP TRIGGER fail_content');
    expect((await repo.load())[1].entry.meaning, 'Updated teaching gloss');
    bundle.files[starterPaths.last] = original;
    expect(
      (await repo.load())[1].revision,
      3,
    ); // An older app cannot downgrade content.
    expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
  });

  test('bad later pack cannot install an earlier pack and stored corruption is detected', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final bundle = ContentTestBundle();
    final repo = SqliteVocabularyRepository(
      db,
      BundledVocabularyRepository(bundle, starterPaths),
    );
    final original = bundle.files[starterPaths.last]!;
    bundle.files[starterPaths.last] = '{}';
    await expectLater(repo.load(), throwsFormatException);
    expect(await db.select(db.contentPacks).get(), isEmpty);
    bundle.files[starterPaths.last] = original;
    await repo.load();
    await (db.delete(
      db.contentExercises,
    )..where((q) => q.position.equals(0))).go();
    await expectLater(repo.load(), throwsFormatException);
    expect(await db.select(db.vocabularyAttempts).get(), isEmpty);
  });

  test('v3 to v4 migration, content upgrade and reopen preserve old learner evidence', () async {
    final directory = await Directory.systemTemp.createTemp(
      'nihao-content-migration-',
    );
    final file = File('${directory.path}/learner.sqlite');
    AppDatabase db = _V3(NativeDatabase(file));
    try {
      final learner = (await SqliteProfileRepository(
        db,
      ).create(const ProfileDraft(name: 'Preserve me'))).selected!;
      final oldWord = loadPilot();
      final oldRepo = SqliteLearningRepository(
        db,
        catalogue: () async => [oldWord],
        now: () => DateTime.utc(2026, 11, 4),
      );
      final session = await oldRepo.begin(
        learner.id,
        oldWord.entry.id,
        review: false,
      );
      final receipt = await oldRepo.submit(session, correctAnswers(oldWord));
      final before = (await db.select(db.vocabularyAttempts).get()).single
          .toJson();
      await db.close();
      final backup = await file.copy('${directory.path}/v3-backup.sqlite');
      db = AppDatabase(NativeDatabase(file));
      final content = SqliteVocabularyRepository(
        db,
        BundledVocabularyRepository(ContentTestBundle(), starterPaths),
      );
      final loaded = await content.load();
      expect(loaded.first.entry.id, oldWord.entry.id);
      expect(loaded.first.revision, 3);
      expect(
        (await db.select(db.vocabularyAttempts).get()).single.toJson(),
        before,
      );
      expect(
        (await db.select(db.vocabularyProgress).get()).single.dueAtMs,
        receipt.nextDueAt.millisecondsSinceEpoch,
      );
      final newRepo = SqliteLearningRepository(
        db,
        catalogue: content.load,
        now: () => receipt.nextDueAt,
      );
      final review = await newRepo.begin(
        learner.id,
        oldWord.entry.id,
        review: true,
      );
      final answers = {
        for (final q in review.word.entry.questions)
          q.id: q.isTyped ? q.correctAnswer : q.correctOptionId,
      };
      await newRepo.submit(review, answers);
      expect(await db.select(db.vocabularyAttempts).get(), hasLength(2));
      await db.close();
      db = AppDatabase(NativeDatabase(file));
      expect(
        (await SqliteProfileRepository(db).load()).selected!.id,
        learner.id,
      );
      expect(await db.select(db.vocabularyAttempts).get(), hasLength(2));
      expect(await db.select(db.contentWords).get(), hasLength(21));
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
      final recovered = _V3(NativeDatabase(backup));
      expect(
        (await recovered.select(recovered.vocabularyAttempts).get()).single
            .toJson(),
        before,
      );
      await recovered.close();
    } finally {
      await db.close();
      if (!directory.absolute.path.startsWith(
        '${Directory.systemTemp.absolute.path}${Platform.pathSeparator}nihao-content-migration-',
      )) {
        throw StateError('Unexpected cleanup path');
      }
      await directory.delete(recursive: true);
    }
  });
}
