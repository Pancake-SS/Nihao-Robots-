import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/data/database_provider.dart';
import 'package:ni_hao_robot/features/grammar/grammar_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/sqlite_vocabulary_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/features/onboarding/foundation_repository.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/profile_home_screen.dart';
import 'package:ni_hao_robot/features/review/learning_providers.dart';
import 'package:ni_hao_robot/shared/robot_art.dart';
import 'package:ni_hao_robot/shared/app_sidebar.dart';

import 'foundation_test_repository.dart';
import 'imported_fixture.dart';
import 'curriculum_fixture.dart';

import 'package:ni_hao_robot/features/vocabulary/curriculum_repository.dart';

Future<void> mountShell(
  WidgetTester tester,
  TestFoundationRepository repository, {
  bool pinyin = true,
  Size size = const Size(1440, 900),
  double scale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final contentDb = AppDatabase(NativeDatabase.memory());
  addTearDown(contentDb.close);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        foundationRepositoryProvider.overrideWithValue(repository),
        appDatabaseProvider.overrideWithValue(contentDb),
        grammarCountsProvider(1)
            .overrideWith((ref) async => const GrammarCounts(428, 0)),
        learningProgressProvider(1).overrideWith((ref) async => []),
        curriculumRepositoryProvider.overrideWithValue(
          StarterQueueFixture(
            contentDb,
            BundledVocabularyRepository(ContentTestBundle(), starterPaths),
          ),
        ),
        vocabularyRepositoryProvider.overrideWithValue(
          SqliteVocabularyRepository(
            contentDb,
            BundledVocabularyRepository(ContentTestBundle(), starterPaths),
          ),
        ),
      ],
      child: MaterialApp(
        theme: buildTheme(),
        home: ProfileHomeScreen(
          profile: LearnerProfile(
            id: 1,
            name: 'Mei',
            level: LearnerLevel.beginner,
            goal: LearningGoal.travel,
            dailyMinutes: 10,
            showPinyin: pinyin,
            createdAt: DateTime.utc(2026, 11, 4),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> press(WidgetTester tester, String label) async {
  final target = find.text(label);
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> navigate(WidgetTester tester, int destination) async {
  final target = find.byKey(ValueKey('destination-$destination'));
  if (target.evaluate().isEmpty) {
    await tester.tap(find.byTooltip('Open navigation sidebar'));
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('desktop sidebar has room for visible navigation labels', (
    tester,
  ) async {
    await mountShell(tester, TestFoundationRepository());
    final sidebar = find.byType(AppSidebar);
    expect(tester.getSize(sidebar).width, 220);
    for (final label in AppSidebar.labels) {
      expect(
        find.descendant(of: sidebar, matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'first visit, leave, resume, finish and replay preserve completion',
    (tester) async {
      final repository = TestFoundationRepository();
      await mountShell(tester, repository);
      expect(find.text('10 minutes a day · Travel'), findsOneWidget);
      await press(tester, 'Start introduction');
      expect(find.byKey(const ValueKey('destination-0')), findsNothing);
      await press(tester, 'Next');
      await press(tester, 'Save and leave');
      expect(find.text('Resume at step 2 of 9'), findsOneWidget);
      await press(tester, 'Resume introduction');
      expect(find.text('Step 2 of 9'), findsOneWidget);
      await press(tester, 'Back');
      expect(find.text('Step 1 of 9'), findsOneWidget);
      for (var i = 0; i < 8; i++) {
        await press(tester, 'Next');
      }
      expect(
        find.text('Audio is not available in this introduction.'),
        findsOneWidget,
      );
      await press(tester, 'Finish introduction');
      expect(repository.states[1]!.completed, isTrue);
      await press(tester, 'Replay introduction');
      expect(find.text('Step 1 of 9'), findsOneWidget);
      await press(tester, 'Save and leave');
      expect(repository.states[1]!.completed, isTrue);
      expect(find.text('Replay introduction'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Pinyin preference hides support but keeps teaching examples', (
    tester,
  ) async {
    final repository = TestFoundationRepository()
      ..states[1] = const FoundationState(step: 5);
    await mountShell(tester, repository, pinyin: false);
    await press(tester, 'Resume introduction');
    expect(find.text('你好'), findsOneWidget);
    expect(find.text('nǐ hǎo'), findsNothing);
    await press(tester, 'Next');
    expect(find.text('nǐ hǎo'), findsOneWidget);
    await press(tester, 'Next');
    expect(find.text('mā · má · mǎ · mà'), findsOneWidget);
    await press(tester, 'Next');
    expect(find.text('Nǐ hǎo!\nZàijiàn!'), findsNothing);
  });

  testWidgets(
    'failed save retains page and pending save blocks duplicate clicks',
    (tester) async {
      final repository = TestFoundationRepository()..failSave = true;
      await mountShell(tester, repository);
      await press(tester, 'Start introduction');
      await press(tester, 'Next');
      expect(find.text('Step 1 of 9'), findsOneWidget);
      expect(find.textContaining('Could not save your place'), findsOneWidget);
      repository.failSave = false;
      repository.saveGate = Completer<void>();
      await tester.tap(find.text('Next'));
      await tester.pump();
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Saving…'))
            .onPressed,
        isNull,
      );
      expect(repository.saves, 2);
      repository.saveGate!.complete();
      await tester.pumpAndSettle();
      expect(find.text('Step 2 of 9'), findsOneWidget);
      expect(repository.states[1]!.step, 1);
    },
  );

  testWidgets(
    'load error has explicit retry without reset or automatic retries',
    (tester) async {
      final repository = TestFoundationRepository()
        ..failLoad = true
        ..states[1] = const FoundationState(step: 6);
      await mountShell(tester, repository);
      expect(find.textContaining('has not been reset'), findsOneWidget);
      repository.failLoad = false;
      await press(tester, 'Try again');
      expect(find.text('Resume at step 7 of 9'), findsOneWidget);
    },
  );

  testWidgets(
    'navigation, distinct mascots, honest milestones and contextual tours',
    (tester) async {
      await mountShell(tester, TestFoundationRepository());
      await press(tester, 'View Details');
      expect(find.textContaining('not fluency scores'), findsOneWidget);
      await press(tester, 'Close');
      await press(tester, 'Replay Tutorial');
      expect(find.text('Begin here'), findsOneWidget);
      // The autofocus Next control can be operated from the keyboard.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Progress with meaning'), findsOneWidget);
      await press(tester, 'Back');
      expect(find.text('Begin here'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Close tutorial'), findsNothing);
      await navigate(tester, 1);
      await press(tester, 'Browse words');
      expect(find.text('Learn words'), findsOneWidget);
      expect(find.text('Learn 你好'), findsOneWidget);
      expect(find.byKey(const ValueKey('destination-0')), findsNothing);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<RobotArt>(find.byType(RobotArt))
            .map((r) => r.artwork)
            .toSet(),
        {
          RobotArtwork.wavingOnPaper,
          RobotArtwork.hoverOnPaper,
          RobotArtwork.orbOnPaper,
          RobotArtwork.gogglesOnPaper,
        },
      );
      await press(tester, 'Replay Tutorial');
      expect(find.text('Learn in context'), findsOneWidget);
      await press(tester, 'Next');
      expect(find.text('Vocabulary practice'), findsOneWidget);
      await press(tester, 'Next');
      expect(find.text('Mastery takes time'), findsOneWidget);
      await press(tester, 'Done');
      await navigate(tester, 2);
      await press(tester, 'Replay Tutorial');
      expect(find.text('Patterns in context'), findsOneWidget);
      await press(tester, 'Done');
      await navigate(tester, 3);
      expect(find.text('0 words ready'), findsOneWidget);
      expect(find.text('Coming soon'), findsNothing);
      await navigate(tester, 4);
      expect(find.text('Explore online'), findsOneWidget);
      expect(find.text('Classical stories'), findsOneWidget);
      expect(find.text('Free writing'), findsOneWidget);
      expect(find.text('Notebook'), findsOneWidget);
      await navigate(tester, 5);
      expect(find.text('Coming soon'), findsOneWidget);
      expect(find.text('Replay Tutorial'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('360px at 200% text supports all introduction pages and tours', (
    tester,
  ) async {
    await mountShell(
      tester,
      TestFoundationRepository(),
      size: const Size(360, 640),
      scale: 2,
    );
    await press(tester, 'Start introduction');
    for (var i = 0; i < 8; i++) {
      await press(tester, 'Next');
      expect(tester.takeException(), isNull);
    }
    await press(tester, 'Finish introduction');
    await press(tester, 'Replay Tutorial');
    await press(tester, 'Next');
    await press(tester, 'Next');
    await press(tester, 'Done');
    await navigate(tester, 1);
    await press(tester, 'Replay Tutorial');
    await press(tester, 'Next');
    await press(tester, 'Close tutorial');
    expect(tester.takeException(), isNull);
  });
}
