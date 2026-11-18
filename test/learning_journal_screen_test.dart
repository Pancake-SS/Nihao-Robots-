import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/data/database_provider.dart';
import 'package:ni_hao_robot/features/learning/learning_journal_repository.dart';
import 'package:ni_hao_robot/features/learning/learning_journal_screen.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/pinyin_input.dart';

Future<void> _waitFor(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (finder.evaluate().isNotEmpty) return;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
  }
  expect(finder, findsWidgets);
}

Future<void> _mount(
  WidgetTester tester,
  AppDatabase db,
  int profile,
  LearningEntryKind kind,
) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        pinyinInputEngineProvider.overrideWith(
          (ref) async => PinyinInputEngine([]),
        ),
      ],
      child: MaterialApp(
        theme: buildTheme(),
        home: LearningJournalScreen(profileId: profile, kind: kind),
      ),
    ),
  );
}

void main() {
  testWidgets('leaving an unsaved note requires a discard choice', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Cautious writer'))).selected!.id;
    await _mount(tester, db, profile, LearningEntryKind.note);
    await tester.tap(find.byKey(const ValueKey('new-learning-entry')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('learning-entry-title')),
      'Draft note',
    );
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Discard your changes?'), findsOneWidget);
    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    expect(find.byType(LearningEntryEditor), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.byType(LearningEntryEditor), findsNothing);
    expect(
      await tester.runAsync(
        () =>
            LearningJournalRepository(db)
                .count(profile, LearningEntryKind.note),
      ),
      0,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(db.close);
  });

  testWidgets('notebook preserves pasted Chinese through scroll and save', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Note taker'))).selected!.id;
    await _mount(tester, db, profile, LearningEntryKind.note);
    await tester.ensureVisible(
      find.byKey(const ValueKey('new-learning-entry')),
    );
    await tester.tap(find.byKey(const ValueKey('new-learning-entry')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('keyboard-modes')),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const ValueKey('keyboard-modes')), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('learning-entry-title')),
      'My reading notes',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('entry-hanzi')));
    expect(find.byKey(const ValueKey('entry-pinyin')), findsNothing);
    expect(find.byKey(const ValueKey('entry-english')), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('entry-hanzi')),
      '今天我看书。 My thoughts: 很有意思。',
    );
    await tester.tap(find.byKey(const ValueKey('save-learning-entry')));
    await _waitFor(tester, find.text('1 saved notes'));
    final repo = LearningJournalRepository(db);
    final saved = (await tester.runAsync(
      () => repo.list(profile, LearningEntryKind.note),
    ))!;
    expect(saved.single.hanzi, '今天我看书。 My thoughts: 很有意思。');
    expect(saved.single.title, 'My reading notes');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(db.close);
  });

  testWidgets('free writing generates a topic and saves independently', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Writer'))).selected!.id;
    await _mount(tester, db, profile, LearningEntryKind.writing);
    await tester.ensureVisible(
      find.byKey(const ValueKey('new-learning-entry')),
    );
    await tester.tap(find.byKey(const ValueKey('new-learning-entry')));
    await tester.pumpAndSettle();
    final oldPrompt = tester
        .widget<Text>(find.byKey(const ValueKey('writing-prompt')))
        .data;
    await tester.tap(find.text('Another topic'));
    await tester.pump();
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('writing-prompt'))).data,
      isNot(oldPrompt),
    );
    await tester.ensureVisible(find.byKey(const ValueKey('entry-hanzi')));
    await tester.enterText(find.byKey(const ValueKey('entry-hanzi')), '我想去中国。');
    await tester.tap(find.byKey(const ValueKey('save-learning-entry')));
    await _waitFor(tester, find.text('1 saved pieces'));
    final repo = LearningJournalRepository(db);
    final saved = (await tester.runAsync(
      () => repo.list(profile, LearningEntryKind.writing),
    ))!;
    expect(saved.single.prompt, isNotEmpty);
    expect(saved.single.hanzi, '我想去中国。');
    expect(
      await tester.runAsync(() => repo.count(profile, LearningEntryKind.note)),
      0,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(db.close);
  });
}
