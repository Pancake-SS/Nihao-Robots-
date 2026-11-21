import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/data/database_provider.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/review/master_repository.dart';
import 'package:ni_hao_robot/features/review/master_screen.dart';
import 'package:ni_hao_robot/features/review/practice_method_screen.dart';
import 'package:ni_hao_robot/features/review/practice_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/pinyin_input.dart';

Future<(AppDatabase, int)> makeWords() async {
  final db = AppDatabase(NativeDatabase.memory());
  final profile = (await SqliteProfileRepository(
    db,
  ).create(const ProfileDraft(name: 'Browser'))).selected!.id;
  for (var i = 0; i < 23; i++) {
    final id = 'word${i.toString().padLeft(2, '0')}';
    await db.customStatement(
      'INSERT INTO curriculum_words '
      '(id,pack_id,revision,content_schema,hanzi,pinyin,meaning,search_text,default_position,metadata_json) '
      'VALUES (?,?,?,?,?,?,?,?,?,?)',
      [
        id,
        'test',
        1,
        4,
        '词$i',
        'cí $i',
        'meaning $i',
        '词$i meaning $i',
        i,
        '{}',
      ],
    );
    await db.customStatement(
      'INSERT INTO vocabulary_progress '
      '(profile_id,word_id,stage,due_at_ms,version,successful_reviews) '
      'VALUES (?,?,?,?,?,?)',
      [profile, id, 'learning', 0, 1, 0],
    );
  }
  await db.customStatement(
    'INSERT INTO mastered_words(profile_id,word_id,mastered_at_ms) VALUES(?,?,?)',
    [profile, 'word21', 0],
  );
  return (db, profile);
}

void main() {
  test(
    'Practice and Master browse 20 at a time with optional search',
    () async {
      final (db, profile) = await makeWords();
      addTearDown(db.close);
      final practice = PracticeRepository(db, (_) async => null);
      final first = await practice.browseLearned(profile, mastered: false);
      expect(first.words, hasLength(20));
      expect(first.hasMore, isTrue);
      expect(first.words.first.id, 'word00');
      final second = await practice.browseLearned(
        profile,
        mastered: false,
        offset: 20,
      );
      expect(second.words.map((word) => word.id), ['word20', 'word22']);
      expect(second.hasMore, isFalse);
      expect(
        (await practice.browseLearned(profile, mastered: true)).words.single.id,
        'word21',
      );
      expect(
        (await practice.browseLearned(
          profile,
          query: 'meaning 22',
          mastered: false,
        )).words.single.id,
        'word22',
      );
      expect(await practice.relearnSearch(profile, 'cí 22'), isEmpty);

      final master = MasterRepository(db, (_) async => null);
      final available = await master.browseAvailable(profile);
      expect(available.words, hasLength(20));
      expect(available.hasMore, isTrue);
      expect(
        (await master.browseAvailable(
          profile,
          offset: 20,
        )).words.map((word) => word.id),
        ['word20', 'word22'],
      );
    },
  );

  testWidgets('Relearn opens with a browsable list and next page', (
    tester,
  ) async {
    final (db, profile) = await makeWords();
    addTearDown(db.close);
    tester.view.physicalSize = const Size(390, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          pinyinInputEngineProvider.overrideWith(
            (ref) async => PinyinInputEngine(const []),
          ),
        ],
        child: MaterialApp(
          theme: buildTheme(),
          home: PracticeMethodScreen(
            profileId: profile,
            route: PracticeRoute.relearn,
            showPinyin: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('practice-word-word00')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Next 20'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Page 1'), findsOneWidget);
    await tester.tap(find.text('Next 20'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('practice-word-word20')),
      -300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const ValueKey('practice-word-word20')), findsOneWidget);
    expect(find.byKey(const ValueKey('practice-word-word00')), findsNothing);
    expect(find.text('Page 2'), findsOneWidget);
  });

  testWidgets('Instant Master browses beyond the first 20 words', (
    tester,
  ) async {
    final (db, profile) = await makeWords();
    addTearDown(db.close);
    tester.view.physicalSize = const Size(390, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          masterRepositoryProvider.overrideWithValue(
            MasterRepository(db, (_) async => null),
          ),
          pinyinInputEngineProvider.overrideWith(
            (ref) async => PinyinInputEngine(const []),
          ),
        ],
        child: MaterialApp(
          theme: buildTheme(),
          home: MasterCandidatesScreen(profileId: profile, instant: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('instant-master-word00')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Next 20'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Next 20'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('instant-master-word20')), findsOneWidget);
    expect(find.byKey(const ValueKey('instant-master-word21')), findsNothing);
    expect(find.text('Page 2'), findsOneWidget);
  });
}
