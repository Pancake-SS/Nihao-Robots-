import 'dart:convert';
import 'dart:io';

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
import 'package:ni_hao_robot/features/review/learning.dart';
import 'package:ni_hao_robot/features/review/master_repository.dart';
import 'package:ni_hao_robot/features/review/master_screen.dart';
import 'package:ni_hao_robot/features/review/practice_repository.dart';
import 'package:ni_hao_robot/features/review/practice_deck.dart';
import 'package:ni_hao_robot/features/review/practice_session_screen.dart';
import 'package:ni_hao_robot/features/review/sqlite_learning_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';

import 'pilot_fixture.dart';

class _VersionSixDatabase extends AppDatabase {
  _VersionSixDatabase(super.executor);
  @override
  int get schemaVersion => 6;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) async {
      final schema = jsonDecode(
        File('docs/schema/drift_schema_v6.json').readAsStringSync(),
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
  test('25 correct points unlock mastery without writing', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Learner'))).selected!.id;
    final other = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Other'))).selected!.id;
    final word = loadPilot();
    final id = word.entry.id;
    final lookup = (String candidate) async => candidate == id ? word : null;
    final learning = SqliteLearningRepository(
      db,
      catalogue: () async => [word],
      lookup: lookup,
    );
    final master = MasterRepository(db, lookup);
    final first = await learning.begin(profile, id, review: false);
    await learning.submit(first, correctAnswers(word));
    final initialHistory =
        (await db.select(db.vocabularyAttempts).get()).length;
    Future<void> complete({bool instant = false}) =>
        master.completeTest(profileId: profile, wordId: id, instant: instant);
    expect(() => complete(), throwsA(isA<MasterConflict>()));
    final current = await learning.progress(profile);
    final needed = 25 - current.single.correctCount;
    for (var i = 0; i < needed; i++) {
      await db
          .into(db.practiceResponses)
          .insert(
            PracticeResponsesCompanion.insert(
              id: newAttemptId(),
              profileId: profile,
              wordId: id,
              questionId: word.entry.questions.first.id,
              correct: true,
              answeredAtMs: DateTime.now().millisecondsSinceEpoch,
            ),
          );
    }
    expect((await learning.progress(profile)).single.correctCount, 25);
    await complete();
    await complete();
    expect(await master.masteredIds(profile), contains(id));
    expect(await master.masteredIds(other), isEmpty);
    expect(await db.select(db.masterWritings).get(), isEmpty);
    expect(await master.returnToLearn(profile, id), isTrue);
    expect(await master.returnToLearn(profile, id), isFalse);
    expect(await master.masteredIds(profile), isEmpty);
    expect(await db.select(db.masterWritings).get(), isEmpty);
    expect(await learning.progress(profile), isEmpty);
    final again = await learning.begin(profile, id, review: false);
    expect(again.versionBefore, greaterThan(first.versionBefore));
    await learning.submit(again, correctAnswers(word));
    expect(
      await db.select(db.vocabularyAttempts).get(),
      hasLength(initialHistory + 1),
    );
    expect(
      (await learning.progress(profile)).single.correctCount,
      greaterThanOrEqualTo(25),
    );
  });

  test('instant master works before 25 points', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Already fluent'))).selected!.id;
    final word = loadPilot();
    final master = MasterRepository(
      db,
      (id) async => id == word.entry.id ? word : null,
    );
    await master.completeTest(
      profileId: profile,
      wordId: word.entry.id,
      instant: true,
    );
    expect(await master.masteredIds(profile), contains(word.entry.id));
    expect(await db.select(db.masterWritings).get(), isEmpty);
  });

  test(
    'instant-master search finds catalogue words and isolates custom words',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final first = (await SqliteProfileRepository(
        db,
      ).create(const ProfileDraft(name: 'First'))).selected!.id;
      final second = (await SqliteProfileRepository(
        db,
      ).create(const ProfileDraft(name: 'Second'))).selected!.id;
      Future<void> add(
        String id,
        String pack,
        String hanzi,
        String meaning,
        String metadata,
      ) => db
          .into(db.curriculumWords)
          .insert(
            CurriculumWordsCompanion.insert(
              id: id,
              packId: pack,
              revision: 1,
              contentSchema: 4,
              hanzi: hanzi,
              pinyin: 'mǎ',
              meaning: meaning,
              searchText: '$hanzi $meaning',
              defaultPosition: 0,
              metadataJson: metadata,
            ),
          );
      await add('public', 'curriculum', '马', 'horse', '{}');
      await add(
        'private',
        'custom.$first',
        '小马',
        'pony',
        '{"ownerProfileId":$first}',
      );
      final master = MasterRepository(db, (_) async => null);
      expect(
        (await master.searchAll(first, '马')).map((w) => w.id),
        containsAll(['public', 'private']),
      );
      expect((await master.searchAll(second, '马')).map((w) => w.id), [
        'public',
      ]);
      for (final id in ['public', 'private']) {
        await db
            .into(db.vocabularyProgress)
            .insert(
              VocabularyProgressCompanion.insert(
                profileId: first,
                wordId: id,
                stage: 'learning',
                dueAtMs: 0,
                version: 1,
                successfulReviews: 0,
              ),
            );
      }
      await db
          .into(db.masteredWords)
          .insert(
            MasteredWordsCompanion.insert(
              profileId: first,
              wordId: 'public',
              masteredAtMs: 0,
            ),
          );
      final practice = PracticeRepository(db, (_) async => null);
      expect(
        (await practice.relearnSearch(
          first,
          '马',
          mastered: true,
        )).map((w) => w.id),
        ['public'],
      );
      expect(
        (await practice.relearnSearch(
          first,
          '马',
          mastered: false,
        )).map((w) => w.id),
        ['private'],
      );
    },
  );

  test('schema 6 upgrades without losing scores or progress', () async {
    final directory = await Directory.systemTemp.createTemp('nihao-master-');
    final file = File('${directory.path}/learner.sqlite');
    final word = loadPilot();
    final old = _VersionSixDatabase(NativeDatabase(file));
    final profile = (await SqliteProfileRepository(
      old,
    ).create(const ProfileDraft(name: 'History'))).selected!.id;
    final learning = SqliteLearningRepository(
      old,
      catalogue: () async => [word],
    );
    final session = await learning.begin(profile, word.entry.id, review: false);
    await learning.submit(session, correctAnswers(word));
    final score = (await learning.progress(profile)).single.correctCount;
    await old.close();
    final db = AppDatabase(NativeDatabase(file));
    try {
      final upgraded = SqliteLearningRepository(
        db,
        catalogue: () async => [word],
      );
      expect((await upgraded.progress(profile)).single.correctCount, score);
      expect(await db.select(db.vocabularyAttempts).get(), hasLength(1));
      expect(await db.select(db.masteredWords).get(), isEmpty);
      expect(await db.select(db.masterWritings).get(), isEmpty);
    } finally {
      await db.close();
      await directory.delete(recursive: true);
    }
  });

  testWidgets('third missed Master answer returns word to Learn', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final db = AppDatabase(NativeDatabase.memory());
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Master learner'))).selected!.id;
    final word = loadPilot();
    final id = word.entry.id;
    final master = MasterRepository(
      db,
      (candidate) async => candidate == id ? word : null,
    );
    await master.completeTest(profileId: profile, wordId: id, instant: true);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          vocabularyLessonProvider(id).overrideWith((ref) async => word),
        ],
        child: MaterialApp(
          theme: buildTheme(),
          home: PracticeSessionScreen(
            profileId: profile,
            mode: PracticeMode.randomWords,
            wordIds: [id],
            count: 1,
            masterPractice: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (var miss = 1; miss <= 3; miss++) {
      final question = word.entry.questions.firstWhere(
        (q) => find.text(q.prompt).evaluate().isNotEmpty,
      );
      final wrong = question.options.keys.firstWhere(
        (option) => option != question.correctOptionId,
      );
      await tester.tap(find.byKey(ValueKey('practice-answer-$wrong')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Check answer'));
      await tester.tap(find.text('Check answer'));
      await tester.pumpAndSettle();
      if (miss < 3) {
        expect(
          find.text('${3 - miss} chances left for this word.'),
          findsOneWidget,
        );
        await tester.ensureVisible(find.text('Next question'));
        await tester.tap(find.text('Next question'));
        await tester.pumpAndSettle();
      }
    }
    expect(find.text('Word returned to Learn'), findsOneWidget);
    expect(await master.masteredIds(profile), isEmpty);
    expect(await db.select(db.masterWritings).get(), isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
    await db.close();
  });

  testWidgets(
    'Master menu and mastered list remain usable in a narrow window',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final db = AppDatabase(NativeDatabase.memory());
      final profile = (await SqliteProfileRepository(
        db,
      ).create(const ProfileDraft(name: 'Small screen'))).selected!.id;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: MaterialApp(
            theme: buildTheme(),
            home: MasterScreen(profileId: profile, showPinyin: true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Ready for Master test'), findsOneWidget);
      expect(find.text('Instant master'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Mastered words'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Mastered words'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'No mastered words yet. Take a Master test when a word reaches 25 points, or choose Instant master.',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), equals(null));
      await tester.pumpWidget(const SizedBox.shrink());
      await db.close();
    },
  );
}
