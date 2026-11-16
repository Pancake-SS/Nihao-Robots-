import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ni_hao_robot/app/app.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/features/onboarding/welcome_screen.dart';
import 'package:ni_hao_robot/shared/cozy_ui.dart';
import 'package:ni_hao_robot/shared/robot_art.dart';
import 'package:ni_hao_robot/features/profiles/profile_providers.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';

import 'profile_test_repository.dart';
import 'foundation_test_repository.dart';

import 'package:ni_hao_robot/features/onboarding/foundation_repository.dart';

Widget withProfiles(Widget child) => ProviderScope(
  overrides: [
    profileRepositoryProvider.overrideWithValue(TestProfileRepository()),
  ],
  child: child,
);

void main() {
  testWidgets(
    'long profile names remain usable at narrow width and 200% text',
    (tester) async {
      final repository = TestProfileRepository();
      await repository.create(
        const ProfileDraft(
          name: 'A long name for our Mandarin learner',
          level: LearnerLevel.experienced,
        ),
      );
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileRepositoryProvider.overrideWithValue(repository),
            foundationRepositoryProvider.overrideWithValue(
              TestFoundationRepository(),
            ),
          ],
          child: const NiHaoRobotApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Continue'));
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Welcome, A long name'), findsOneWidget);
      await tester.ensureVisible(find.text('Switch profile'));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('welcome uses the supplied reading robot in the dark panel', (
    tester,
  ) async {
    await tester.pumpWidget(withProfiles(const NiHaoRobotApp()));
    await tester.pumpAndSettle();

    expect(find.text('NI HAO ROBOT!'), findsOneWidget);
    expect(find.text('Create local profile'), findsOneWidget);
    expect(find.byType(NightStudyScene), findsOneWidget);
    final robots = tester.widgetList<RobotArt>(find.byType(RobotArt));
    expect(robots.map((robot) => robot.artwork).toSet(), {
      RobotArtwork.wavingOnPaper,
    });
    final reading = tester.widget<Image>(
      find.byKey(const ValueKey('welcome-reading-robot')),
    );
    expect(
      (reading.image as AssetImage).assetName,
      'assets/ui_art/welcome_reading_robot.png',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('small window and large text scroll without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      withProfiles(
        MaterialApp(
          theme: buildTheme(),
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 640),
              textScaler: TextScaler.linear(2),
            ),
            child: const WelcomeScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.byType(RobotArt).last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  for (final size in [const Size(1440, 900), const Size(900, 700)]) {
    testWidgets('welcome fits desktop window $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(withProfiles(const NiHaoRobotApp()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(RobotArt), findsOneWidget);
      expect(
        find.byKey(const ValueKey('welcome-reading-robot')),
        findsOneWidget,
      );
    });
  }
}
