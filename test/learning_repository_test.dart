import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/onboarding/foundation_repository.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/review/learning.dart';
import 'package:ni_hao_robot/features/review/sqlite_learning_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';

import 'pilot_fixture.dart';

class _VersionTwoFixture extends AppDatabase {
  _VersionTwoFixture(super.executor);
  @override
  int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) async {
      final schema = jsonDecode(
        File('docs/schema/drift_schema_v2.json').readAsStringSync(),
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
  final word = loadPilot();
  final id = word.entry.id;
  final correct = correctAnswers(word);
  final incorrect = {...correct, word.entry.questions.first.id: 'goodbye'};
  final conflict = throwsA(isA<LearningConflict>());
  late AppDatabase db;
  late SqliteLearningRepository repository;
  late DateTime clock;
  late List<CatalogueWord> catalogue;
  late int profile, other;

  setUp(() async {
    clock = DateTime.utc(2026, 11, 4, 12, 0, 0, 123);
    catalogue = [word];
    db = AppDatabase(NativeDatabase.memory());
    final profiles = SqliteProfileRepository(db);
    profile = (await profiles.create(const ProfileDraft(name: 'Learner')))
        .selected!
        .id;
    other = (await profiles.create(const ProfileDraft(name: 'Learner')))
        .selected!
        .id;
    repository = SqliteLearningRepository(
      db,
      catalogue: () async => catalogue,
      now: () => clock,
    );
  });
  tearDown(() => db.close());

  test(
    'failed review schedule update preserves old progress and attempt history',
    () async {
      final initial = await repository.begin(profile, id, review: false);
      clock = (await repository.submit(initial, correct)).nextDueAt;
      final review = await repository.begin(profile, id, review: true);
      await db.customStatement(
        "CREATE TRIGGER reject_review BEFORE UPDATE ON vocabulary_progress BEGIN SELECT RAISE(ABORT, 'test'); END",
      );
      await expectLater(
        repository.submit(review, incorrect),
        throwsA(isA<Exception>()),
      );
      expect(await db.select(db.vocabularyAttempts).get(), hasLength(1));
      expect((await repository.progress(profile)).single.version, 1);
      await db.customStatement('DROP TRIGGER reject_review');
      await repository.submit(review, incorrect);
      expect(await db.select(db.vocabularyAttempts).get(), hasLength(2));
      expect(
        (await repository.progress(profile)).single.stage,
        LearningStage.relearning,
      );
    },
  );

  test('first quiz commits immutable evidence and schedule without mastery or cross-profile changes', () async {
    final session = await repository.begin(profile, id, review: false);
    expect(await repository.progress(profile), isEmpty);
    final saved = await repository.submit(session, correct);
    expect(saved.passed, isTrue);
    expect(saved.stage, LearningStage.learning);
    expect(saved.nextDueAt, clock.add(const Duration(minutes: 5)));
    final progress = (await repository.progress(profile)).single;
    expect(progress.successfulReviews, 0);
    expect(progress.version, 1);
    expect(await repository.progress(other), isEmpty);
    final event = (await db.select(db.vocabularyAttempts).get()).single;
    expect(event.answersJson, contains('hello'));
    expect((jsonDecode(event.questionsJson) as List).length, 2);
    expect(event.packId, word.packId);
    expect(event.contentRevision, word.revision);
    await expectLater(repository.begin(profile, id, review: false), conflict);
  });

  test(
    'review eligibility is exact at due time and rechecked on submit',
    () async {
      final first = await repository.begin(profile, id, review: false);
      final receipt = await repository.submit(first, correct);
      clock = receipt.nextDueAt.subtract(const Duration(milliseconds: 1));
      await expectLater(repository.begin(profile, id, review: true), conflict);
      clock = receipt.nextDueAt;
      final review = await repository.begin(profile, id, review: true);
      clock = clock.subtract(const Duration(seconds: 1));
      await expectLater(repository.submit(review, correct), conflict);
      clock = receipt.nextDueAt;
      final saved = await repository.submit(review, correct);
      expect(saved.stage, LearningStage.review);
      expect(saved.nextDueAt, clock.add(const Duration(days: 1)));
      expect((await repository.progress(profile)).single.successfulReviews, 1);
    },
  );

  test('incorrect initial and delayed answers retain history and schedule relearning', () async {
    final first = await repository.begin(profile, id, review: false);
    final failed = await repository.submit(first, incorrect);
    expect(failed.passed, isFalse);
    expect(failed.stage, LearningStage.relearning);
    final original = (await db.select(db.vocabularyAttempts).get()).single;
    clock = failed.nextDueAt;
    final review = await repository.begin(profile, id, review: true);
    final second = await repository.submit(review, incorrect);
    expect(second.stage, LearningStage.relearning);
    clock = second.nextDueAt;
    final retry = await repository.begin(profile, id, review: true);
    await repository.submit(retry, correct);
    final history = await db.select(db.vocabularyAttempts).get();
    expect(history, hasLength(3));
    expect(history.first, original);
    expect((await repository.progress(profile)).single.successfulReviews, 1);
  });

  test(
    'same event retry returns original receipt even after content removal',
    () async {
      final session = await repository.begin(profile, id, review: false);
      final receipt = await repository.submit(session, correct);
      clock = clock.add(const Duration(days: 2));
      catalogue = [];
      final retried = await repository.submit(session, correct);
      expect(retried.nextDueAt, receipt.nextDueAt);
      expect(retried.answeredAt, receipt.answeredAt);
      expect(await db.select(db.vocabularyAttempts).get(), hasLength(1));
      expect((await repository.progress(profile)).single.version, 1);
      await expectLater(repository.begin(profile, id, review: true), conflict);
      await expectLater(repository.submit(session, incorrect), conflict);
    },
  );

  test('same event cannot be reused under another profile', () async {
    final session = await repository.begin(profile, id, review: false);
    await repository.submit(session, correct);
    final forged = QuizSession(
      eventId: session.eventId,
      profileId: other,
      word: word,
      versionBefore: 0,
      isReview: false,
    );
    await expectLater(repository.submit(forged, correct), conflict);
    expect(await repository.progress(other), isEmpty);
  });

  test(
    'two open sessions race without duplicate attempts or schedule changes',
    () async {
      final a = await repository.begin(profile, id, review: false);
      final b = await repository.begin(profile, id, review: false);
      Future<String> submit(QuizSession session) async {
        try {
          await repository.submit(session, correct);
          return 'saved';
        } on LearningConflict {
          return 'conflict';
        }
      }

      expect(
        await Future.wait([submit(a), submit(b)]),
        unorderedEquals(['saved', 'conflict']),
      );
      expect(await db.select(db.vocabularyAttempts).get(), hasLength(1));
      expect((await repository.progress(profile)).single.version, 1);
    },
  );

  test(
    'schedule failure rolls back attempt; retry records it exactly once',
    () async {
      final session = await repository.begin(profile, id, review: false);
      await db.customStatement(
        "CREATE TRIGGER reject_schedule BEFORE INSERT ON vocabulary_progress BEGIN SELECT RAISE(ABORT, 'test'); END",
      );
      await expectLater(
        repository.submit(session, correct),
        throwsA(isA<Exception>()),
      );
      expect(await db.select(db.vocabularyAttempts).get(), isEmpty);
      expect(await repository.progress(profile), isEmpty);
      await db.customStatement('DROP TRIGGER reject_schedule');
      await repository.submit(session, correct);
      expect(await db.select(db.vocabularyAttempts).get(), hasLength(1));
    },
  );

  test('invalid answers, missing profiles, and revised content cannot write progress', () async {
    final session = await repository.begin(profile, id, review: false);
    await expectLater(repository.submit(session, {}), throwsArgumentError);
    await expectLater(
      repository.submit(session, {...correct, 'extra': 'hello'}),
      throwsArgumentError,
    );
    await expectLater(
      repository.submit(session, {
        ...correct,
        word.entry.questions.first.id: 'unknown',
      }),
      throwsArgumentError,
    );
    await expectLater(repository.begin(999, id, review: false), conflict);
    await expectLater(repository.progress(999), conflict);
    catalogue = [CatalogueWord(word.packId, word.revision + 1, word.entry)];
    await expectLater(repository.submit(session, correct), conflict);
    expect(await db.select(db.vocabularyAttempts).get(), isEmpty);
  });

  test(
    'caller mutation cannot change submitted answers after submission begins',
    () async {
      final session = await repository.begin(profile, id, review: false);
      final selections = {...correct};
      final pending = repository.submit(session, selections);
      selections.clear();
      expect((await pending).passed, isTrue);
    },
  );

  test('early policy is configurable and rejects invalid intervals', () async {
    expect(
      () => EarlyReviewPolicy(firstDelay: Duration.zero),
      throwsArgumentError,
    );
    expect(
      () => EarlyReviewPolicy(reviewDelay: const Duration(days: 31)),
      throwsArgumentError,
    );
    final custom = SqliteLearningRepository(
      db,
      catalogue: () async => catalogue,
      now: () => clock,
      policy: EarlyReviewPolicy(firstDelay: const Duration(seconds: 3)),
    );
    final session = await custom.begin(profile, id, review: false);
    expect(
      (await custom.submit(session, correct)).nextDueAt,
      clock.add(const Duration(seconds: 3)),
    );
  });

  test('v2 migration and restart retain profiles, onboarding, attempts and due dates', () async {
    await db.close();
    final directory = await Directory.systemTemp.createTemp('nihao-v3-test-');
    final file = File('${directory.path}/learner.sqlite');
    AppDatabase? connection;
    try {
      connection = _VersionTwoFixture(NativeDatabase(file));
      final profileState = await SqliteProfileRepository(connection)
          .create(const ProfileDraft(name: 'Mei', showPinyin: false));
      final learner = profileState.selected!.id;
      await SqliteFoundationRepository(connection)
          .save(learner, 8, complete: true);
      await connection.close();
      connection = null;
      final backup = await file.copy('${directory.path}/before-v3.sqlite');
      connection = AppDatabase(NativeDatabase(file));
      expect(
        (await SqliteProfileRepository(connection).load()).selected!.showPinyin,
        isFalse,
      );
      expect(
        (await SqliteFoundationRepository(connection).load(learner)).completed,
        isTrue,
      );
      var repo = SqliteLearningRepository(
        connection,
        catalogue: () async => [word],
        now: () => clock,
      );
      final session = await repo.begin(learner, id, review: false);
      final receipt = await repo.submit(session, correct);
      await connection.close();
      connection = AppDatabase(NativeDatabase(file));
      repo = SqliteLearningRepository(
        connection,
        catalogue: () async => [word],
        now: () => clock,
      );
      expect((await repo.progress(learner)).single.dueAt, receipt.nextDueAt);
      expect(
        await connection.select(connection.vocabularyAttempts).get(),
        hasLength(1),
      );
      expect(
        (await repo.submit(session, correct)).nextDueAt,
        receipt.nextDueAt,
      );
      clock = receipt.nextDueAt;
      await repo.submit(await repo.begin(learner, id, review: true), correct);
      expect(
        await connection.select(connection.vocabularyAttempts).get(),
        hasLength(2),
      );
      expect(
        await connection.customSelect('PRAGMA foreign_key_check').get(),
        isEmpty,
      );
      await connection.close();
      connection = AppDatabase(NativeDatabase(backup));
      expect(
        (await SqliteFoundationRepository(connection).load(learner)).completed,
        isTrue,
      );
      expect(
        await connection.select(connection.vocabularyAttempts).get(),
        isEmpty,
      );
    } finally {
      await connection?.close();
      final prefix =
          '${Directory.systemTemp.absolute.path}${Platform.pathSeparator}nihao-v3-test-';
      if (!directory.absolute.path.startsWith(prefix))
        throw StateError('Unexpected cleanup path');
      await directory.delete(recursive: true);
      db = AppDatabase(NativeDatabase.memory());
    }
  });
}
