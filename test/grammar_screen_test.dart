import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/data/database_provider.dart';
import 'package:ni_hao_robot/features/grammar/grammar_repository.dart';
import 'package:ni_hao_robot/features/grammar/grammar_screen.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/pinyin_input.dart';

void main() {
  Future<void> waitFor(WidgetTester tester, Finder finder) async {
    for (var attempt = 0; attempt < 20; attempt++) {
      await tester.pump();
      if (finder.evaluate().isNotEmpty) return;
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
    }
    expect(finder, findsWidgets);
  }

  testWidgets(
    'pending lesson moves to Completed and remains readable at 360px',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final db = AppDatabase(NativeDatabase.memory());
      final profile = (await SqliteProfileRepository(
        db,
      ).create(const ProfileDraft(name: 'Learner'))).selected!.id;
      final repo = GrammarRepository(db);
      await tester.runAsync(repo.ready);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            grammarRepositoryProvider.overrideWithValue(repo),
            pinyinInputEngineProvider.overrideWith(
              (ref) async => PinyinInputEngine([]),
            ),
          ],
          child: MaterialApp(
            theme: buildTheme(),
            home: Scaffold(
              body: SingleChildScrollView(
                child: GrammarHomeContent(profileId: profile, showPinyin: true),
              ),
            ),
          ),
        ),
      );
      await waitFor(tester, find.text('Pending lessons · 428'));
      await tester.tap(find.byKey(const ValueKey('grammar-pending')));
      await waitFor(tester, find.text('428 lessons'));
      final first = (await tester.runAsync(
        () => repo.page(profile, completed: false),
      ))!.lessons.first;
      await tester.tap(find.byKey(ValueKey('grammar-lesson-${first.id}')));
      await waitFor(tester, find.text('What it means'));
      expect(find.text(first.title), findsWidgets);
      expect(find.text('What it means'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Mark lesson completed'),
        260,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Mark lesson completed'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.textContaining('Completed'), findsWidgets);
      Navigator.of(tester.element(find.byType(GrammarLessonScreen))).pop();
      await waitFor(tester, find.text('427 lessons'));
      Navigator.of(tester.element(find.byType(GrammarListScreen))).pop();
      await waitFor(tester, find.text('Completed lessons · 1'));
      expect(tester.takeException(), equals(null));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(db.close);
    },
  );
}
