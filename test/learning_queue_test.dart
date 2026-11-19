import 'dart:io';

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
import 'package:ni_hao_robot/features/vocabulary/learning_keyboard.dart';
import 'package:ni_hao_robot/features/vocabulary/pinyin_input.dart';
import 'package:ni_hao_robot/features/vocabulary/word_library.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';

import 'curriculum_fixture.dart';

// Keep UI clock control deterministic; real SQL paging/moves/restart are covered
// in curriculum_repository_test with this same imported data.
class _QueueViewFixture extends CurriculumRepository {
  _QueueViewFixture(super.database, this.rows, this.word);
  final List<QueueWord> rows;
  final CatalogueWord word;
  final offsets = <int>[];
  final searches = <String>[];
  @override
  Future<QueuePage> page(
    int profile, {
    int offset = 0,
    String search = '',
    int? priority,
    WordCategory? category,
    bool priorityOrder = false,
  }) async {
    offsets.add(offset);
    searches.add(search);
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
    'queue requests 20 at a time, replaces pages, highlights and opens the selected lesson at large text',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final keyboard = PinyinInputEngine(
        WordLibrary.parse(
          File('assets/content/dictionary_v1.json').readAsStringSync(),
        ).words,
      );
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
            pinyinInputEngineProvider.overrideWith((ref) async => keyboard),
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
      expect(find.byKey(const ValueKey('import-custom-words')), findsOneWidget);
      expect(find.byType(LearningKeyboard), findsOneWidget);
      expect(find.byKey(const ValueKey('queue-search')), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('queue-search')),
        'nihao',
      );
      await tester.pumpAndSettle();
      final candidate = find.byKey(const ValueKey('candidate-你好'));
      await tester.ensureVisible(candidate);
      await tester.tap(candidate);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(find.byKey(const ValueKey('queue-search')))
            .controller!
            .text,
        '你好',
      );
      await tester.tap(find.byTooltip('Search queue'));
      await tester.pumpAndSettle();
      expect(repo.searches.last, '你好');
      repo.offsets.removeLast();
      expect(find.text('Page 1'), findsOneWidget);
      await tester.tap(find.byTooltip('Filter words'));
      await tester.pumpAndSettle();
      expect(find.text('Word filters'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Move up'), findsNothing);
      await tester.tap(find.byTooltip('Next 20 words'));
      await tester.pumpAndSettle();
      expect(repo.offsets.take(2), [0, 20]);
      expect(find.text('Page 2'), findsOneWidget);
      expect(find.byKey(ValueKey('queue-${repo.rows.first.id}')), findsNothing);
      await tester.tap(find.byTooltip('Previous 20 words'));
      await tester.pumpAndSettle();
      expect(find.text('Page 1'), findsOneWidget);
      await tester.tap(find.byTooltip('Next 20 words'));
      await tester.pumpAndSettle();
      final more = await repo.page(profile, offset: 20);
      final selected = more.words[3];
      final row = find.byKey(ValueKey('queue-${selected.id}'));
      await tester.scrollUntilVisible(
        row,
        400,
        scrollable: find.descendant(
          of: find.byType(GridView),
          matching: find.byType(Scrollable),
        ),
        maxScrolls: 40,
      );
      await tester.pumpAndSettle();
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(find.text('Learn ${selected.hanzi}'), findsOneWidget);
      // Footer remains reachable even at 200% text without scrolling back.
      expect(
        find.byKey(const ValueKey('learn-selected')).hitTestable(),
        findsOneWidget,
      );
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
