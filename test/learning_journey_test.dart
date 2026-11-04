import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/app.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/data/database_provider.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/review/learning.dart';
import 'package:ni_hao_robot/features/review/learning_providers.dart';
import 'package:ni_hao_robot/features/review/quiz_screen.dart';
import 'package:ni_hao_robot/features/review/review_screen.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';
import 'package:ni_hao_robot/features/review/sqlite_learning_repository.dart';

import 'pilot_fixture.dart';

Future<void> press(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> answerQuiz(WidgetTester tester, {bool correct = true}) async {
  await press(
    tester,
    find.byKey(ValueKey(correct ? 'answer-hello' : 'answer-goodbye')),
  );
  await press(tester, find.text('Next question'));
  await press(tester, find.byKey(const ValueKey('answer-hello')));
  await press(tester, find.text('Save answers'));
}

class _LostAcknowledgement implements LearningRepository {
  _LostAcknowledgement(this.inner);
  final LearningRepository inner;
  final retried = Completer<void>();
  final sessions = <String>[];
  @override
  Future<List<WordProgress>> progress(int id) => inner.progress(id);
  @override
  Future<QuizSession> begin(int id, String word, {required bool review}) =>
      inner.begin(id, word, review: review);
  @override
  Future<SavedAttempt> submit(
    QuizSession session,
    Map<String, String> answers,
  ) async {
    sessions.add(session.eventId);
    if (sessions.length == 1) {
      await inner.submit(session, answers);
      throw StateError('Simulated lost acknowledgement after commit');
    }
    await retried.future;
    return inner.submit(session, answers);
  }
}

void main() {
  testWidgets(
    'missing lesson content retains a due record without a broken review action',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final profile = (await SqliteProfileRepository(
        db,
      ).create(const ProfileDraft(name: 'Mei'))).selected!;
      final word = loadPilot();
      var clock = DateTime.utc(2026, 11, 4, 12);
      final repo = SqliteLearningRepository(
        db,
        catalogue: () async => [word],
        now: () => clock,
      );
      final session = await repo.begin(
        profile.id,
        word.entry.id,
        review: false,
      );
      clock = (await repo.submit(session, correctAnswers(word))).nextDueAt;
      try {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              learningRepositoryProvider.overrideWithValue(repo),
              learningClockProvider.overrideWithValue(() => clock),
              vocabularyCatalogueProvider.overrideWith((ref) async => []),
            ],
            child: MaterialApp(
              theme: buildTheme(),
              home: ReviewScreen(profileId: profile.id),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('1 due · 1 in early learning'), findsOneWidget);
        expect(find.text('Lesson content unavailable'), findsOneWidget);
        expect(find.text('Review now'), findsNothing);
        expect(await db.select(db.vocabularyAttempts).get(), hasLength(1));
        expect((await repo.progress(profile.id)).single.version, 1);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await db.close();
      }
    },
  );

  testWidgets(
    'learn, quiz, due review, failure, SQLite restart, recovery and profile isolation',
    (tester) async {
      final directory = (await tester.runAsync(
        () => Directory.systemTemp.createTemp('nihao-journey-test-'),
      ))!;
      final file = File('${directory.path}/learner.sqlite');
      AppDatabase? db;
      var clock = DateTime.utc(2026, 11, 4, 12);
      var first = 0, second = 0;
      Future<void> open({bool seed = false}) async {
        db = AppDatabase(NativeDatabase(file));
        await tester.runAsync(() async {
          final profiles = SqliteProfileRepository(db!);
          if (seed) {
            first = (await profiles.create(const ProfileDraft(name: 'Mei')))
                .selected!
                .id;
            second = (await profiles.create(const ProfileDraft(name: 'Other')))
                .selected!
                .id;
            await profiles.select(first);
          } else {
            await profiles.load();
          }
        });
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appDatabaseProvider.overrideWithValue(db!),
              learningClockProvider.overrideWithValue(() => clock),
            ],
            child: const NiHaoRobotApp(),
          ),
        );
        await tester.pumpAndSettle();
      }

      try {
        await open(seed: true);
        await press(tester, find.text('Continue'));
        await press(tester, find.byKey(const ValueKey('destination-1')));
        await press(tester, find.text('Browse words'));
        await press(tester, find.text('Explore word'));
        expect(find.text('Example 5'), findsOneWidget);
        expect(find.textContaining('teacher review pending'), findsWidgets);
        await press(tester, find.text('Continue to Quiz'));
        await answerQuiz(tester);
        expect(find.text('Attempt saved'), findsOneWidget);
        expect(await db!.select(db!.vocabularyAttempts).get(), hasLength(1));
        await press(tester, find.text('Done'));
        expect(find.text('Continue to Quiz'), findsNothing);
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();
        await press(tester, find.text('Open reviews'));
        expect(find.text('0 due · 1 in early learning'), findsOneWidget);
        expect(find.text('Review now'), findsNothing);
        final firstDue =
            (await db!.select(db!.vocabularyProgress).get()).single.dueAtMs;
        clock = DateTime.fromMillisecondsSinceEpoch(firstDue - 1, isUtc: true);
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Review now'), findsNothing);
        clock = DateTime.fromMillisecondsSinceEpoch(firstDue, isUtc: true);
        await tester.pump(const Duration(seconds: 1));
        await press(tester, find.text('Review now'));
        await answerQuiz(tester, correct: false);
        expect(find.textContaining('Keep practising'), findsOneWidget);
        final row = (await db!.select(db!.vocabularyProgress).get()).single;
        expect(row.stage, 'relearning');
        expect(await db!.select(db!.vocabularyAttempts).get(), hasLength(2));
        clock = DateTime.fromMillisecondsSinceEpoch(row.dueAtMs, isUtc: true);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(db!.close);
        db = null;

        await open();
        await press(tester, find.text('Continue'));
        await press(tester, find.byKey(const ValueKey('destination-1')));
        await press(tester, find.text('Open reviews'));
        expect(find.text('1 due · 1 in early learning'), findsOneWidget);
        await press(tester, find.text('Review now'));
        await answerQuiz(tester);
        final history = await db!.select(db!.vocabularyAttempts).get();
        expect(history.map((a) => a.passed), [true, false, true]);
        expect(
          (await db!.select(db!.vocabularyProgress).get())
              .single
              .successfulReviews,
          1,
        );
        await press(tester, find.text('Done'));
        await tester.pageBack();
        await tester.pumpAndSettle();
        await press(tester, find.text('Switch profile'));
        await press(tester, find.byKey(ValueKey('profile-$second')));
        await press(tester, find.text('Continue'));
        await press(tester, find.byKey(const ValueKey('destination-1')));
        await press(tester, find.text('Open reviews'));
        expect(find.text('0 due · 0 in early learning'), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(() async {
          await db?.close();
          final prefix =
              '${Directory.systemTemp.absolute.path}${Platform.pathSeparator}nihao-journey-test-';
          if (!directory.absolute.path.startsWith(prefix))
            throw StateError('Unexpected cleanup path');
          await directory.delete(recursive: true);
        });
      }
    },
  );

  testWidgets(
    'ambiguous save freezes submitted choices and retries one event at 200% text',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final profile = (await SqliteProfileRepository(
        db,
      ).create(const ProfileDraft(name: 'Mei'))).selected!;
      final word = loadPilot();
      final repository = _LostAcknowledgement(
        SqliteLearningRepository(
          db,
          catalogue: () async => [word],
          now: () => DateTime.utc(2026, 11, 4, 12),
        ),
      );
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      try {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              learningRepositoryProvider.overrideWithValue(repository),
            ],
            child: MaterialApp(
              theme: buildTheme(),
              home: QuizScreen(
                profileId: profile.id,
                wordId: word.entry.id,
                review: false,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await answerQuiz(tester);
        expect(
          find.textContaining('Could not confirm the save'),
          findsOneWidget,
        );
        expect(
          tester
              .widget<OutlinedButton>(
                find.byKey(const ValueKey('answer-please')),
              )
              .onPressed,
          isNull,
        );
        await tester.ensureVisible(find.text('Try saving again'));
        await tester.tap(find.text('Try saving again'));
        await tester.pump();
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Saving…'),
              )
              .onPressed,
          isNull,
        );
        repository.retried.complete();
        await tester.pumpAndSettle();
        expect(find.text('Attempt saved'), findsOneWidget);
        expect(repository.sessions[0], repository.sessions[1]);
        expect(await db.select(db.vocabularyAttempts).get(), hasLength(1));
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await db.close();
      }
    },
  );
}
