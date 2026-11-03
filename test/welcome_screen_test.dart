import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/app.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/features/onboarding/welcome_screen.dart';
import 'package:ni_hao_robot/shared/robot_art.dart';

void main() {
  testWidgets('welcome labels future learning honestly and uses distinct originals', (tester) async {
    await tester.pumpWidget(const NiHaoRobotApp());
    await tester.pumpAndSettle();

    expect(find.text('NI HAO ROBOT!'), findsOneWidget);
    expect(find.text('Coming soon: local learner profiles and your first lesson.'), findsOneWidget);
    final robots = tester.widgetList<RobotArt>(find.byType(RobotArt));
    expect(robots.map((robot) => robot.artwork).toSet(), {
      RobotArtwork.wavingOnPaper,
      RobotArtwork.orbOnNavy,
    });
    expect(tester.takeException(), isNull);
  });

  testWidgets('small window and large text scroll without overflow', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
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
      await tester.pumpWidget(const NiHaoRobotApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(RobotArt), findsNWidgets(2));
    });
  }
}
