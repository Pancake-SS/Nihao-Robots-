import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/review/master_repository.dart';
import 'package:ni_hao_robot/features/review/master_test_screen.dart';

class _InstantMasterFixture extends MasterRepository {
  _InstantMasterFixture(AppDatabase database)
    : super(database, (_) async => null);

  int calls = 0;
  bool fail = false;

  @override
  Future<void> completeTest({
    required int profileId,
    required String wordId,
    required bool instant,
  }) async {
    calls++;
    expect(profileId, 1);
    expect(wordId, 'test.word');
    expect(instant, isTrue);
    if (fail) throw const MasterConflict('Try again.');
  }
}

void main() {
  testWidgets('Instant Master asks first and cancellation leaves the word', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = _InstantMasterFixture(db);
    bool? completed;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [masterRepositoryProvider.overrideWithValue(repository)],
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
    expect(
      find.textContaining('without a quiz or 10 correct points'),
      findsOneWidget,
    );
    expect(find.text('Start full word test'), findsNothing);
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(completed, isFalse);
    expect(repository.calls, 0);

    repository.fail = true;
    await tester.tap(find.text('Try Instant Master'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Master this word'));
    await tester.pumpAndSettle();
    expect(find.text('Try again.'), findsOneWidget);
    expect(completed, isFalse);
    repository.fail = false;
    await tester.tap(find.byKey(const ValueKey('confirm-instant-master')));
    await tester.pumpAndSettle();
    expect(repository.calls, 2);
    expect(completed, isTrue);
    expect(find.text('Start full word test'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
