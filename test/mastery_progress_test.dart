import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/shared/dashboard_widgets.dart';

void main() {
  testWidgets('home mastery flags follow real word counts', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> show(int count) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: JourneyProgress(count: count)),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await show(500);
    expect(find.text('500 / 11147 words mastered'), findsOneWidget);
    expect(find.text('500 words until the 1k flag'), findsOneWidget);
    expect(JourneyProgress.milestones, hasLength(13));
    expect(JourneyProgress.milestones.first, 100);
    expect(JourneyProgress.milestones.last, 11000);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('mastery-flag-500')),
        matching: find.byIcon(Icons.flag),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('mastery-flag-1000')),
        matching: find.byIcon(Icons.outlined_flag),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await show(11000);
    expect(find.text('All milestone flags reached!'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('mastery-flag-11000')),
        matching: find.byIcon(Icons.flag),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
