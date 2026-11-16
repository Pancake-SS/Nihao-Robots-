import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/data/database_provider.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/review/practice_deck.dart';
import 'package:ni_hao_robot/features/review/practice_repository.dart';
import 'package:ni_hao_robot/features/review/practice_session_screen.dart';
import 'package:ni_hao_robot/features/review/sqlite_learning_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/content_pack.dart';
import 'package:ni_hao_robot/features/vocabulary/sqlite_vocabulary_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';

import 'pilot_fixture.dart';
import 'imported_fixture.dart';

class _VersionFiveDatabase extends AppDatabase {
  _VersionFiveDatabase(super.executor);
  @override
  int get schemaVersion => 5;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) async {
      final schema = jsonDecode(
        File('docs/schema/drift_schema_v5.json').readAsStringSync(),
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
  test(
    'schema 5 upgrade backfills correct first answers without losing history',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'nihao-practice-',
      );
      final file = File('${directory.path}/learner.sqlite');
      final word = loadPilot();
      var old = _VersionFiveDatabase(NativeDatabase(file));
      final profile = (await SqliteProfileRepository(
        old,
      ).create(const ProfileDraft(name: 'History'))).selected!.id;
      final repo = SqliteLearningRepository(old, catalogue: () async => [word]);
      final session = await repo.begin(profile, word.entry.id, review: false);
      await repo.submit(session, correctAnswers(word));
      expect(await old.select(old.vocabularyAttempts).get(), hasLength(1));
      await old.close();
      final db = AppDatabase(NativeDatabase(file));
      try {
        final upgraded = SqliteLearningRepository(
          db,
          catalogue: () async => [word],
        );
        expect(
          (await upgraded.progress(profile)).single.correctCount,
          word.entry.questions.length,
        );
        expect(await db.select(db.vocabularyAttempts).get(), hasLength(1));
      } finally {
        await db.close();
        await directory.delete(recursive: true);
      }
    },
  );

  test(
    'practice points persist, deduplicate and stay within a profile',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final profiles = SqliteProfileRepository(db);
      final first = (await profiles.create(const ProfileDraft(name: 'First')))
          .selected!
          .id;
      final second = (await profiles.create(const ProfileDraft(name: 'Second')))
          .selected!
          .id;
      final word = loadPilot();
      final lookup = (String id) async => id == word.entry.id ? word : null;
      final learning = SqliteLearningRepository(
        db,
        catalogue: () async => [word],
        lookup: lookup,
      );
      final initial = await learning.begin(first, word.entry.id, review: false);
      await learning.submit(initial, correctAnswers(word));
      expect(
        (await learning.progress(first)).single.correctCount,
        word.entry.questions.length,
      );
      expect(await learning.progress(second), isEmpty);

      final practice = PracticeRepository(db, lookup);
      final question = word.entry.questions.first;
      final correct = question.isTyped
          ? question.correctAnswer
          : question.correctOptionId;
      expect(
        await practice.recordFirstResponse(
          eventId: 'practice-1',
          profileId: first,
          wordId: word.entry.id,
          questionId: question.id,
          answer: correct,
        ),
        isTrue,
      );
      expect(
        await practice.recordFirstResponse(
          eventId: 'practice-1',
          profileId: first,
          wordId: word.entry.id,
          questionId: question.id,
          answer: correct,
        ),
        isTrue,
      );
      expect(
        (await learning.progress(first)).single.correctCount,
        word.entry.questions.length + 1,
      );
      expect(await learning.progress(second), isEmpty);

      final other = word.entry.questions.last;
      final wrong = other.isTyped
          ? '错'
          : other.options.keys.firstWhere((id) => id != other.correctOptionId);
      expect(
        await practice.recordFirstResponse(
          eventId: 'practice-2',
          profileId: first,
          wordId: word.entry.id,
          questionId: other.id,
          answer: wrong,
        ),
        isFalse,
      );
      expect(
        (await learning.progress(first)).single.correctCount,
        word.entry.questions.length + 1,
      );
    },
  );

  test(
    'relearning matches Hanzi or English, never overlapping Pinyin',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final profile = (await SqliteProfileRepository(
        db,
      ).create(const ProfileDraft(name: 'Reader'))).selected!.id;
      final word = loadPilot();
      await SqliteLearningRepository(db, catalogue: () async => [word])
          .begin(profile, word.entry.id, review: false)
          .then(
            (session) => SqliteLearningRepository(
              db,
              catalogue: () async => [word],
            ).submit(session, correctAnswers(word)),
          );
      await db.customStatement(
        'INSERT INTO curriculum_words '
        '(id, pack_id, revision, content_schema, hanzi, pinyin, meaning, '
        'search_text, default_position, metadata_json) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          word.entry.id,
          word.packId,
          word.revision,
          2,
          word.entry.hanzi,
          word.entry.pinyin,
          word.entry.meaning,
          '',
          0,
          '{}',
        ],
      );
      final practice = PracticeRepository(db, (id) async => word);
      expect(
        await practice.relearnSearch(profile, word.entry.hanzi),
        hasLength(1),
      );
      expect(
        await practice.relearnSearch(profile, word.entry.meaning),
        hasLength(1),
      );
      expect(await practice.relearnSearch(profile, word.entry.pinyin), isEmpty);
      await db.customStatement('DELETE FROM curriculum_words WHERE id = ?', [
        word.entry.id,
      ]);
      await SqliteVocabularyRepository(
        db,
        BundledVocabularyRepository(ContentTestBundle(), starterPaths),
      ).load();
      expect(
        await practice.relearnSearch(profile, word.entry.hanzi),
        hasLength(1),
      );
    },
  );

  test(
    'random uses distinct words and endless draws every question once',
    () async {
      final pack = VocabularyPack.parse(
        File('assets/content/starter_imported_v1.json').readAsStringSync(),
      );
      final words = [
        for (final entry in pack.entries.take(3))
          CatalogueWord(pack.id, pack.revision, entry),
      ];
      final byId = {for (final word in words) word.entry.id: word};
      Future<CatalogueWord?> lookup(String id) async => byId[id];
      final random = PracticeDeck(
        mode: PracticeMode.randomWords,
        wordIds: byId.keys,
        count: 2,
        random: Random(4),
      );
      final selected = await random.nextBatch(lookup);
      expect(selected, hasLength(2));
      expect(selected.map((item) => item.wordId).toSet(), hasLength(2));
      expect(await random.nextBatch(lookup), isEmpty);

      final paged = PracticeDeck(
        mode: PracticeMode.randomWords,
        wordIds: byId.keys,
        count: 3,
        random: Random(9),
      );
      final firstBatch = await paged.nextBatch(lookup, batchSize: 2);
      final secondBatch = await paged.nextBatch(lookup, batchSize: 2);
      expect(firstBatch, hasLength(2));
      expect(secondBatch, hasLength(1));
      expect({
        for (final item in [...firstBatch, ...secondBatch]) item.wordId,
      }, hasLength(3));
      expect(await paged.nextBatch(lookup), isEmpty);

      final endless = PracticeDeck(
        mode: PracticeMode.endless,
        wordIds: byId.keys,
        random: Random(4),
      );
      final all = <String>{};
      while (true) {
        final batch = await endless.nextBatch(lookup, batchSize: 5);
        if (batch.isEmpty) break;
        for (final item in batch) {
          expect(all.add(item.question.id), isTrue);
        }
      }
      expect(
        all.length,
        words.fold(0, (sum, word) => sum + word.entry.questions.length),
      );
    },
  );

  testWidgets('numbered random practice saves one response per distinct word', (
    tester,
  ) async {
    final pack = VocabularyPack.parse(
      File('assets/content/starter_imported_v1.json').readAsStringSync(),
    );
    final words = [
      for (final entry in pack.entries.take(2))
        CatalogueWord(pack.id, pack.revision, entry),
    ];
    final byId = {for (final word in words) word.entry.id: word};
    Future<CatalogueWord?> lookup(String id) async => byId[id];
    final db = AppDatabase(NativeDatabase.memory());
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Quizzer'))).selected!.id;
    final learning = SqliteLearningRepository(
      db,
      catalogue: () async => words,
      lookup: lookup,
    );
    for (final word in words) {
      final session = await learning.begin(
        profile,
        word.entry.id,
        review: false,
      );
      await learning.submit(session, correctAnswers(word));
    }
    final before = (await db.select(db.practiceResponses).get()).length;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          vocabularyLessonProvider(words[0].entry.id)
              .overrideWith((ref) => lookup(words[0].entry.id)),
          vocabularyLessonProvider(words[1].entry.id)
              .overrideWith((ref) => lookup(words[1].entry.id)),
          practiceRepositoryProvider.overrideWithValue(
            PracticeRepository(db, lookup),
          ),
        ],
        child: MaterialApp(
          theme: buildTheme(),
          home: PracticeSessionScreen(
            profileId: profile,
            mode: PracticeMode.randomWords,
            wordIds: byId.keys.toList(),
            count: 2,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (var i = 0; i < 2; i++) {
      final question = words
          .expand((word) => word.entry.questions)
          .firstWhere((q) => find.text(q.prompt).evaluate().isNotEmpty);
      if (question.isTyped) {
        await tester.enterText(
          find.byKey(const ValueKey('practice-typed-answer')),
          question.correctAnswer,
        );
      } else {
        await tester.tap(
          find.byKey(ValueKey('practice-answer-${question.correctOptionId}')),
        );
      }
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check answer'));
      await tester.pumpAndSettle();
      expect(find.text('Correct! +1 point'), findsOneWidget);
      await tester.tap(find.text(i == 0 ? 'Next question' : 'Finish round'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Session complete'), findsOneWidget);
    expect((await db.select(db.practiceResponses).get()).length, before + 2);
    await tester.pumpWidget(const SizedBox.shrink());
    await db.close();
  });
}
