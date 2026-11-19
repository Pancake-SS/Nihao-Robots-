import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/vocabulary/add_word_screen.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/curriculum_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/custom_word.dart';
import 'package:ni_hao_robot/features/vocabulary/edit_custom_word_screen.dart';
import 'package:ni_hao_robot/features/vocabulary/pinyin_input.dart';

import 'curriculum_fixture.dart';

const draft = CustomWordDraft(
  hanzi: '机器人咖啡馆',
  pinyin: 'jī qì rén kā fēi guǎn',
  meaning: 'robot cafe',
  explanation: 'A cafe served by robots.',
  examples: [
    CustomSentence(
      '这个机器人咖啡馆很大。',
      'Zhège jīqìrén kāfēiguǎn hěn dà.',
      'This robot cafe is big.',
    ),
    CustomSentence(
      '我喜欢这个机器人咖啡馆。',
      'Wǒ xǐhuan zhège jīqìrén kāfēiguǎn.',
      'I like this robot cafe.',
    ),
    CustomSentence(
      '那个机器人咖啡馆很远。',
      'Nàge jīqìrén kāfēiguǎn hěn yuǎn.',
      'That robot cafe is far away.',
    ),
    CustomSentence(
      '机器人咖啡馆里有水。',
      'Jīqìrén kāfēiguǎn lǐ yǒu shuǐ.',
      'There is water in the robot cafe.',
    ),
    CustomSentence(
      '这是新的机器人咖啡馆。',
      'Zhè shì xīn de jīqìrén kāfēiguǎn.',
      'This is a new robot cafe.',
    ),
  ],
);

CustomWordDraft importedDraft(String hanzi, String pinyin, String meaning) =>
    CustomWordDraft(
      hanzi: hanzi,
      pinyin: pinyin,
      meaning: meaning,
      imported: true,
      examples: [
        for (var i = 1; i <= 5; i++)
          CustomSentence(
            '我喜欢$hanzi$i。',
            'Wǒ xǐhuan $pinyin $i.',
            'I like $meaning number $i.',
          ),
      ],
    );

void main() {
  test(
    'editing a custom word keeps its identity, progress, and lesson links',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final profiles = SqliteProfileRepository(db);
      final owner = (await profiles.create(const ProfileDraft(name: 'Owner')))
          .selected!
          .id;
      final other = (await profiles.create(const ProfileDraft(name: 'Other')))
          .selected!
          .id;
      final repo = fullCurriculum(db);
      final saved = await repo.addCustomWord(owner, draft);
      final queueBefore = await db
          .customSelect(
            'SELECT position FROM learning_queue WHERE profile_id=? AND word_id=?',
            variables: [Variable(owner), Variable(saved.id)],
          )
          .getSingle();
      final original = await repo.editableCustomWord(owner, saved.id);
      expect(original?.examples, hasLength(5));
      expect(await repo.editableCustomWord(other, saved.id), isNull);
      await db.customStatement(
        '''
      INSERT INTO vocabulary_progress(profile_id,word_id,stage,due_at_ms,version,successful_reviews)
      VALUES(?,?,'review',0,1,12)
    ''',
        [owner, saved.id],
      );
      final edited = CustomWordDraft(
        hanzi: draft.hanzi,
        pinyin: draft.pinyin,
        meaning: 'robot coffee shop',
        examples: [
          CustomSentence(
            draft.examples.first.hanzi,
            draft.examples.first.pinyin,
            'This robot coffee shop is spacious.',
          ),
          ...draft.examples.skip(1),
        ],
        explanation: 'A place for coffee with robots.',
      );
      await expectLater(
        repo.updateCustomWord(other, saved.id, edited),
        throwsStateError,
      );
      await repo.updateCustomWord(owner, saved.id, edited);
      final lesson = (await repo.lesson(saved.id))!;
      expect(lesson.entry.id, saved.id);
      expect(lesson.revision, 2);
      expect(lesson.entry.meaning, edited.meaning);
      expect(
        lesson.entry.examples.first.meaning,
        edited.examples.first.meaning,
      );
      expect(lesson.entry.customExplanation, edited.explanation);
      expect(lesson.entry.questions, isNotEmpty);
      final queueAfter = await db
          .customSelect(
            'SELECT position FROM learning_queue WHERE profile_id=? AND word_id=?',
            variables: [Variable(owner), Variable(saved.id)],
          )
          .getSingle();
      expect(
        queueAfter.read<int>('position'),
        queueBefore.read<int>('position'),
      );
      final progress = await db
          .customSelect(
            'SELECT successful_reviews FROM vocabulary_progress WHERE profile_id=? AND word_id=?',
            variables: [Variable(owner), Variable(saved.id)],
          )
          .getSingle();
      expect(progress.read<int>('successful_reviews'), 12);
      final conflicting = CustomWordDraft(
        hanzi: edited.hanzi,
        pinyin: edited.pinyin,
        meaning: 'robot bookshop',
        examples: edited.examples,
      );
      await repo.addCustomWord(
        owner,
        importedDraft('机器人书店', 'jī qì rén shū diàn', 'robot bookshop'),
      );
      await expectLater(
        repo.updateCustomWord(owner, saved.id, conflicting),
        throwsA(isA<CustomWordConflict>()),
      );
      expect((await repo.lesson(saved.id))!.entry.meaning, edited.meaning);
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    },
  );

  test(
    'CSV batches keep row order and roll back if one word clashes',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final profile = (await SqliteProfileRepository(
        db,
      ).create(const ProfileDraft(name: 'Importer'))).selected!.id;
      final repo = fullCurriculum(db);
      final first = importedDraft(
        '机器人咖啡馆',
        'jī qì rén kā fēi guǎn',
        'robot cafe',
      );
      final second = importedDraft(
        '机器人书店',
        'jī qì rén shū diàn',
        'robot bookshop',
      );
      final saved = await repo.importCustomWords(profile, [first, second]);
      expect(saved.map((word) => word.hanzi), [first.hanzi, second.hanzi]);
      expect(
        (await repo.page(profile)).words.take(2).map((word) => word.id),
        saved.map((word) => word.id),
      );
      final lesson = (await repo.lesson(saved.first.id))!;
      expect(lesson.entry.examples, hasLength(5));
      expect(lesson.entry.questions.length, greaterThanOrEqualTo(7));
      expect(
        lesson.entry.examples.first.credit,
        'Imported from learner-provided text',
      );
      final third = importedDraft(
        '机器人茶馆',
        'jī qì rén chá guǎn',
        'robot tea house',
      );
      await expectLater(
        repo.importCustomWords(profile, [first, third]),
        throwsA(isA<CustomWordConflict>()),
      );
      expect(
        (await repo.page(profile, category: WordCategory.customWords)).words,
        hasLength(2),
      );
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    },
  );

  test(
    'custom questions prefer related choices and reject missing examples',
    () {
      final country = CustomWordDraft(
        hanzi: '美國',
        pinyin: 'měi guó',
        meaning: 'America',
        examples: draft.examples,
      );
      final questions = CustomWordQuestions.build(
        'custom.test',
        country,
        const [
          CustomChoiceWord('中国', 'zhōng guó', 'China'),
          CustomChoiceWord('日本', 'rì běn', 'Japan'),
          CustomChoiceWord('韩国', 'hán guó', 'South Korea'),
          CustomChoiceWord('苹果', 'píng guǒ', 'apple'),
        ],
      );
      final meaning = questions.first;
      final choices = (meaning['options'] as List)
          .cast<Map<String, String>>()
          .map((e) => e['text'])
          .toSet();
      expect(
        choices,
        containsAll(['America', 'China', 'Japan', 'South Korea']),
      );
      expect(choices, isNot(contains('apple')));
      expect(
        () => const CustomWordDraft(
          hanzi: '机器人咖啡馆',
          pinyin: 'jī qì rén kā fēi guǎn',
          meaning: 'robot cafe',
          examples: [],
        ).validate(),
        throwsFormatException,
      );
    },
  );

  test(
    'saved custom lesson is linked, prioritized, private and detects clashes',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final profiles = SqliteProfileRepository(db);
      final first = (await profiles.create(const ProfileDraft(name: 'First')))
          .selected!
          .id;
      final second = (await profiles.create(const ProfileDraft(name: 'Second')))
          .selected!
          .id;
      final repo = fullCurriculum(db);
      final saved = await repo.addCustomWord(first, draft);
      expect((await repo.page(first)).words.first.id, saved.id);
      expect((await repo.page(first, priority: 0)).words.first.id, saved.id);
      expect(
        (await repo.page(
          first,
          category: WordCategory.customWords,
        )).words.single.id,
        saved.id,
      );
      expect(
        (await repo.page(second, category: WordCategory.customWords)).words,
        isEmpty,
      );
      final lesson = (await repo.lesson(saved.id))!;
      expect(lesson.entry.examples, hasLength(5));
      expect(lesson.entry.questions.length, greaterThanOrEqualTo(7));
      expect(lesson.entry.customExplanation, draft.explanation);
      expect(lesson.entry.reviewStatus, 'user-created');
      expect(lesson.entry.examples.every((e) => e.audio == null), isTrue);
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
      final clash = await repo.findCustomClash(
        first,
        draft.hanzi,
        draft.pinyin,
        draft.meaning,
      );
      expect(clash!.word.id, saved.id);
      expect(clash.fields, containsAll(['Hanzi', 'Pinyin', 'English meaning']));
      final pinyinClash = await repo.findCustomClash(
        first,
        '${draft.hanzi}甲',
        draft.pinyin,
        'made up learning term',
      );
      expect(pinyinClash!.word.id, saved.id);
      expect(pinyinClash.fields, contains('Pinyin'));
      final meaningClash = await repo.findCustomClash(
        first,
        '${draft.hanzi}乙',
        'quán xīn cí',
        draft.meaning,
      );
      expect(meaningClash!.word.id, saved.id);
      expect(meaningClash.fields, contains('English meaning'));
      await expectLater(
        repo.addCustomWord(first, draft),
        throwsA(isA<CustomWordConflict>()),
      );
      expect((await repo.lesson(saved.id))!.entry.questions, isNotEmpty);

      // A later bundled curriculum revision must keep learner-written rows.
      final manifest = jsonDecode(
        File('assets/content/curriculum.manifest.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      final upgraded = CurriculumRepository(
        db,
        seedFile: File('assets/content/curriculum.sqlite'),
        manifest: {...manifest, 'revision': (manifest['revision'] as int) + 1},
      );
      await upgraded.ready();
      expect((await upgraded.lesson(saved.id))!.entry.examples, hasLength(5));
      expect((await upgraded.page(first)).words.first.id, saved.id);
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    },
  );

  testWidgets('add word checks fields and opens the five-example page', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Editor'))).selected!.id;
    final repo = fullCurriculum(db);
    await tester.runAsync(repo.ready);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          curriculumRepositoryProvider.overrideWithValue(repo),
          pinyinInputEngineProvider.overrideWith(
            (ref) async => PinyinInputEngine([]),
          ),
        ],
        child: MaterialApp(home: AddWordScreen(profileId: profile)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('custom-word-hanzi')),
      draft.hanzi,
    );
    await tester.enterText(
      find.byKey(const ValueKey('custom-word-pinyin')),
      draft.pinyin,
    );
    await tester.enterText(
      find.byKey(const ValueKey('custom-word-meaning')),
      draft.meaning,
    );
    await tester.ensureVisible(find.text('Check word and continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check word and continue'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Examples for ${draft.hanzi}'), findsOneWidget);
    expect(find.textContaining('five different sentences'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await db.close();
  }, timeout: const Timeout(Duration(minutes: 2)));

  testWidgets('edit form preloads a custom word for editing', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Edit form'))).selected!.id;
    final repo = fullCurriculum(db);
    await tester.runAsync(repo.ready);
    final saved = (await tester.runAsync(
      () => repo.addCustomWord(profile, draft),
    ))!;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          curriculumRepositoryProvider.overrideWithValue(repo),
          pinyinInputEngineProvider.overrideWith(
            (ref) async => PinyinInputEngine([]),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => FilledButton(
                onPressed: () => Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditCustomWordScreen(
                      profileId: profile,
                      wordId: saved.id,
                    ),
                  ),
                ),
                child: const Text('Open edit'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open edit'));
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('edit-custom-hanzi')),
          )
          .controller!
          .text,
      draft.hanzi,
    );
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('edit-custom-meaning')))
          .controller!
          .text,
      draft.meaning,
    );
    await tester.enterText(
      find.byKey(const ValueKey('edit-custom-meaning')),
      'robot coffee house',
    );
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('edit-custom-meaning')))
          .controller!
          .text,
      'robot coffee house',
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  }, timeout: const Timeout(Duration(minutes: 2)));
}
