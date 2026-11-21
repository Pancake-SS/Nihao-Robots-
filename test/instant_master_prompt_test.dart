import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/review/master_test_screen.dart';

void main() {
  testWidgets('Instant Master asks first and cancellation leaves the word', (
    tester,
  ) async {
    bool? completed;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => FilledButton(
                onPressed: () async => completed = await offerInstantMaster(
                  context,
                  profileId: 1,
                  wordId: 'test.word',
                  hanzi: '你好',
                ),
                child: const Text('Try Instant Master'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Try Instant Master'));
    await tester.pumpAndSettle();
    expect(find.text('Instant master 你好?'), findsOneWidget);
    expect(find.textContaining('25 correct points'), findsOneWidget);
    expect(find.text('Start full word test'), findsNothing);
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(completed, isFalse);

    await tester.tap(find.text('Try Instant Master'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Master test'));
    await tester.pumpAndSettle();
    expect(find.text('Start full word test'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(completed, isFalse);
    expect(tester.takeException(), isNull);
  });
}
