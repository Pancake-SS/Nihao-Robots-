import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/review/master_test_screen.dart';

void main() {
  testWidgets('Master test starts with one full quiz and no writing step', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MasterTestScreen(
          profileId: 1,
          wordId: 'test.word',
          hanzi: '你好',
          instant: false,
        ),
      ),
    );
    expect(find.text('Start full word test'), findsOneWidget);
    expect(find.textContaining('writing'), findsNothing);
    expect(find.textContaining('gallery'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
