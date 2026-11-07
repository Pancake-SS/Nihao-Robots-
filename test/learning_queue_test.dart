import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/data/database_provider.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/curriculum_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/learning_queue_screen.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';

import 'curriculum_fixture.dart';

// Keep UI clock control deterministic; real SQL paging/moves/restart are covered
// in curriculum_repository_test with this same imported data.
class _QueueViewFixture extends CurriculumRepository {
  _QueueViewFixture(super.database, this.rows, this.word);
  final List<QueueWord> rows;
  final CatalogueWord word;
  final offsets = <int>[];
  @override
  Future<QueuePage> page(
    int profile, {
    int offset = 0,
    String search = '',
  }) async {
    offsets.add(offset);
    return QueuePage(
      rows.skip(offset).take(20).toList(),
      rows.length > offset + 20,
    );
  }

  @override
  Future<void> move(int profile, String id, String direction) async {
    final row = rows.firstWhere((w) => w.id == id);
    rows.remove(row);
    rows.insert(0, row);
  }

  @override
  Future<CatalogueWord?> lesson(String id) async =>
      id == word.entry.id ? word : null;
}

void main() {
  testWidgets(
    'queue requests 20 at a time, highlights, reorders and opens the selected lesson at large text',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final storage = fullCurriculum(db);
      late _QueueViewFixture repo;
      late int profile;
      await tester.runAsync(() async {
        profile = (await SqliteProfileRepository(
          db,
        ).create(const ProfileDraft(name: 'Queue'))).selected!.id;
        final first = await storage.page(profile);
        final second = await storage.page(profile, offset: 20);
        repo = _QueueViewFixture(db, [
          ...first.words,
          ...second.words,
        ], (await storage.lesson(second.words[3].id))!);
      });
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            curriculumRepositoryProvider.overrideWithValue(repo),
          ],
          child: MaterialApp(
            theme: buildTheme(),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: LearningQueueScreen(profileId: profile, showPinyin: true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('20 words shown · 20 at a time'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('See 20 more'),
        600,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 40,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('See 20 more'));
      await tester.pumpAndSettle();
      expect(repo.offsets.take(2), [0, 20]);
      final more = await repo.page(profile, offset: 20);
      final selected = more.words[3];
      final row = find.byKey(ValueKey('queue-${selected.id}'));
      await tester.scrollUntilVisible(
        row,
        400,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 40,
      );
      await tester.pumpAndSettle();
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(tester.widget<ListTile>(row).selected, isTrue);
      await tester.scrollUntilVisible(
        find.text('Move to front'),
        -800,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 40,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Move to front'));
      await tester.pumpAndSettle();
      expect((await repo.page(profile)).words.first.id, selected.id);
      await tester.ensureVisible(find.byKey(const ValueKey('learn-selected')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('learn-selected')));
      await tester.pumpAndSettle();
      expect(find.text('Meet a word'), findsOneWidget);
      expect(find.text(selected.hanzi), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await db.close();
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
