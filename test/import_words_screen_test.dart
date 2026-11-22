import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/vocabulary/add_word_screen.dart';
import 'package:ni_hao_robot/features/vocabulary/curriculum_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/custom_word.dart';
import 'package:ni_hao_robot/features/vocabulary/custom_word_csv.dart';
import 'package:ni_hao_robot/features/vocabulary/import_words_screen.dart';

class _ImportFixture extends CurriculumRepository {
  _ImportFixture(super.database);
  List<CustomWordDraft>? received;
  int checks = 0;

  @override
  Future<CustomWordClash?> findCustomClash(
    int profile,
    String hanzi,
    String pinyin,
    String meaning,
  ) async {
    checks++;
    return null;
  }

  @override
  Future<List<QueueWord>> importCustomWords(
    int profile,
    List<CustomWordDraft> drafts,
  ) async {
    received = drafts;
    return [
      for (var i = 0; i < drafts.length; i++)
        QueueWord(
          'custom.test.$i',
          drafts[i].hanzi,
          drafts[i].pinyin,
          drafts[i].meaning,
        ),
    ];
  }
}

class _ExistingWordFixture extends _ImportFixture {
  _ExistingWordFixture(super.database);

  CustomWordDraft? attached;

  @override
  Future<CustomWordClash?> findCustomClash(
    int profile,
    String hanzi,
    String pinyin,
    String meaning,
  ) async => CustomWordClash(
    QueueWord('bundled.existing', hanzi, pinyin, meaning),
    const ['Hanzi', 'Pinyin', 'English meaning'],
    true,
  );

  @override
  Future<void> attachExamplesToExistingWord(
    int profile,
    String id,
    CustomWordDraft draft,
  ) async {
    attached = draft;
  }

  @override
  Future<void> bringToFront(int profile, String id) async {}
}

String _csv() {
  final values = [
    '机器人咖啡馆',
    'jī qì rén kā fēi guǎn',
    'robot cafe',
    for (var i = 1; i <= 5; i++) ...[
      '这个机器人咖啡馆很大$i。',
      'Zhège jīqìrén kāfēiguǎn hěn dà $i.',
      'This robot cafe is big, example $i.',
    ],
    'A cafe with robots.',
  ];
  return '${CustomWordCsv.header}\n${values.map((value) => '"${value.replaceAll('"', '""')}"').join(',')}';
}

void main() {
  testWidgets('existing word import saves its five examples', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = _ExistingWordFixture(db);
    AddedWordResult? result;
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => FilledButton(
                onPressed: () async {
                  result = await Navigator.of(context).push<AddedWordResult>(
                    MaterialPageRoute(
                      builder: (_) => const ImportWordsScreen(profileId: 1),
                    ),
                  );
                },
                child: const Text('Open import'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open import'));
    await tester.pumpAndSettle();
    final csvField = find.byKey(const ValueKey('import-csv-text'));
    await tester.scrollUntilVisible(
      csvField,
      280,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(csvField, _csv());
    final check = find.byKey(const ValueKey('import-check-csv'));
    await Scrollable.ensureVisible(tester.element(check), alignment: 0.5);
    await tester.pumpAndSettle();
    final outerScroll = Scrollable.of(tester.element(check));
    outerScroll.position.jumpTo(outerScroll.position.maxScrollExtent);
    await tester.pumpAndSettle();
    await tester.tap(check);
    await tester.pumpAndSettle();
    final save = find.byKey(const ValueKey('save-examples-to-existing-word'));
    outerScroll.position.jumpTo(outerScroll.position.maxScrollExtent);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(repository.attached?.examples, hasLength(5));
    expect(result?.id, 'bundled.existing');
    expect(result?.openLesson, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('previews five examples and imports the word', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = _ImportFixture(db);
    AddedWordResult? result;
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [curriculumRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => FilledButton(
                onPressed: () async {
                  result = await Navigator.of(context).push<AddedWordResult>(
                    MaterialPageRoute(
                      builder: (_) => const ImportWordsScreen(profileId: 1),
                    ),
                  );
                },
                child: const Text('Open import'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open import'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('copy-word-import-prompt')),
      findsOneWidget,
    );

    final csvField = find.byKey(const ValueKey('import-csv-text'));
    await tester.scrollUntilVisible(
      csvField,
      280,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(csvField, _csv());
    expect(tester.widget<TextField>(csvField).controller!.text, _csv());
    final check = find.byKey(const ValueKey('import-check-csv'));
    await Scrollable.ensureVisible(tester.element(check), alignment: 0.5);
    await tester.pumpAndSettle();
    final outerScroll = Scrollable.of(tester.element(check));
    outerScroll.position.jumpTo(outerScroll.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(check.hitTestable(), findsOneWidget);
    await tester.tap(check);
    await tester.pumpAndSettle();
    expect(repository.checks, 1);
    outerScroll.position.jumpTo(outerScroll.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(find.text('1 word checked'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('import-preview-0')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widgetList<SelectableText>(find.byType(SelectableText))
          .any(
            (widget) =>
                widget.data?.contains('This robot cafe is big, example 5.') ??
                false,
          ),
      isTrue,
    );
    final confirm = find.byKey(const ValueKey('confirm-import-words'));
    outerScroll.position.jumpTo(outerScroll.position.maxScrollExtent);
    await tester.pumpAndSettle();
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(result?.id, 'custom.test.0');
    expect(repository.received?.single.examples, hasLength(5));
    expect(repository.received?.single.imported, isTrue);
    expect(tester.takeException(), isNull);
  });
}
