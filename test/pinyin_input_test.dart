import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/review/chinese_answer_input.dart';
import 'package:ni_hao_robot/features/vocabulary/pinyin_input.dart';
import 'package:ni_hao_robot/features/vocabulary/word_library.dart';

void main() {
  late WordLibrary library;
  late PinyinInputEngine engine;
  setUpAll(() {
    library = WordLibrary.parse(
      File('assets/content/dictionary_v1.json').readAsStringSync(),
    );
    engine = PinyinInputEngine(library.words);
  });

  testWidgets(
    'production keyboard provider loads the bundled offline dictionary',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final loaded = await tester.runAsync(
        () => container.read(pinyinInputEngineProvider.future),
      );
      expect(loaded!.candidates('nihao').map((c) => c.hanzi), contains('你好'));
    },
  );

  testWidgets(
    'failed keyboard loading preserves direct answers and supports retry',
    (tester) async {
      var attempts = 0;
      var answer = '';
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pinyinInputEngineProvider.overrideWith((ref) async {
              if (++attempts == 1) throw StateError('test load failure');
              return engine;
            }),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ChineseAnswerInput(
                  answerKey: const ValueKey('answer'),
                  initialValue: '',
                  enabled: true,
                  onChanged: (value) => answer = value,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('answer')), '书shu');
      expect(answer, '书shu');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Retry keyboard'));
      await tester.pumpAndSettle();
      expect(attempts, 2);
      expect(
        tester
            .widget<TextFormField>(find.byKey(const ValueKey('answer')))
            .controller!
            .text,
        '书shu',
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('candidate-书')), findsOneWidget);
    },
  );

  test('all curriculum words are available through their own Pinyin without quiz context', () {
    for (final word in library.words) {
      for (final reading in word.pinyinNumbered.split('/')) {
        final input = PinyinInputEngine.normalize(reading);
        expect(input, isNotEmpty, reason: word.id);
        var found = false;
        for (var offset = 0; offset < 20000; offset += 20) {
          final candidates = engine.candidates(
            input,
            offset: offset,
            limit: 20,
          );
          if (candidates.any((c) => c.hanzi == word.hanzi)) {
            found = true;
            break;
          }
          if (candidates.length < 20) break;
        }
        expect(found, isTrue, reason: word.id);
      }
    }
  });

  test('normalizes tones, spacing, umlauts and rejects malformed input', () {
    for (final value in ['nihao', 'NI HAO', "ni'hao", 'ni3 hao3', 'nǐ hǎo']) {
      expect(engine.candidates(value).map((c) => c.hanzi), contains('你好'));
    }
    for (final value in ['nv', 'nü', 'nǚ', 'nu:3']) {
      expect(engine.candidates(value).map((c) => c.hanzi), contains('女'));
    }
    for (final value in ['', '123', '你好', '<script>', 'a' * 61]) {
      expect(engine.candidates(value), isEmpty);
    }
    expect(() => engine.candidates('ni', offset: -1), throwsArgumentError);
  });

  test('exact words precede completions and homophone pages do not repeat', () {
    final first = engine.candidates('shi', limit: 8);
    final second = engine.candidates('shi', offset: 8, limit: 8);
    expect(first, hasLength(8));
    expect(second, hasLength(8));
    expect(
      first
          .map((c) => c.hanzi)
          .toSet()
          .intersection(second.map((c) => c.hanzi).toSet()),
      isEmpty,
    );
    expect(engine.candidates('nihao').first.hanzi, '你好');
  });

  test('character suggestions compose words absent from the dictionary', () {
    final cupboard = engine
        .candidates('gui')
        .firstWhere((candidate) => candidate.hanzi == '柜');
    expect(cupboard.sourceWord, '柜子');
    expect(cupboard.pinyin, 'guì');
    expect(
      engine.candidates('gui', limit: 8).map((candidate) => candidate.hanzi),
      contains('柜'),
    );
    final split = engine.firstSyllable('binggui')!;
    expect(split.firstSyllable, 'bing');
    expect(split.remaining, 'gui');
    expect(split.candidates.map((candidate) => candidate.hanzi), contains('冰'));
    expect(engine.firstSyllable('bing1gui4')!.rawPrefixLength, 5);
  });

  testWidgets('answer keyboard converts binggui one syllable at a time', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var answer = '';
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pinyinInputEngineProvider.overrideWith((ref) async => engine),
        ],
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: Scaffold(
            body: SingleChildScrollView(
              child: ChineseAnswerInput(
                answerKey: const ValueKey('freezer-answer'),
                initialValue: '',
                enabled: true,
                onChanged: (value) => answer = value,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('freezer-answer')),
      'binggui',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('candidate-冰')));
    await tester.tap(find.byKey(const ValueKey('candidate-冰')));
    await tester.pumpAndSettle();
    expect(answer, '冰gui');
    await tester.ensureVisible(find.byKey(const ValueKey('candidate-柜')));
    await tester.tap(find.byKey(const ValueKey('candidate-柜')));
    await tester.pumpAndSettle();
    expect(answer, '冰柜');
    expect(tester.takeException(), isNull);
  });

  test('alternate readings fill only the selected marked Pinyin', () {
    expect(
      engine.candidates('shei').firstWhere((c) => c.hanzi == '谁').pinyin,
      'shéi',
    );
    expect(
      engine.candidates('shui').firstWhere((c) => c.hanzi == '谁').pinyin,
      'shuí',
    );
  });

  testWidgets(
    'keyboard composes, replaces selection, preserves edits and freezes after submission at 200% text',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var enabled = true;
      var answer = '';
      late StateSetter update;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pinyinInputEngineProvider.overrideWith((ref) async => engine),
          ],
          child: MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: Scaffold(
              body: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (context, state) {
                    update = state;
                    return ChineseAnswerInput(
                      answerKey: const ValueKey('answer'),
                      initialValue: '',
                      enabled: enabled,
                      onChanged: (value) => answer = value,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('answer'));
      await tester.enterText(field, 'nihao');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('candidate-你好')));
      await tester.tap(find.byKey(const ValueKey('candidate-你好')));
      await tester.pumpAndSettle();
      expect(answer, '你好');
      final controller = tester
          .widget<TextFormField>(find.byKey(const ValueKey('answer')))
          .controller!;
      controller.selection = const TextSelection(
        baseOffset: 0,
        extentOffset: 2,
      );
      await tester.ensureVisible(find.text('Show keys'));
      await tester.tap(find.text('Show keys'));
      await tester.pumpAndSettle();
      for (final letter in ['s', 'h', 'u']) {
        await tester.ensureVisible(find.widgetWithText(OutlinedButton, letter));
        await tester.tap(find.widgetWithText(OutlinedButton, letter));
        await tester.pumpAndSettle();
      }
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('candidate-书')));
      await tester.tap(find.byKey(const ValueKey('candidate-书')));
      await tester.pumpAndSettle();
      expect(answer, '书');
      await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'n'));
      await tester.tap(find.widgetWithText(OutlinedButton, 'n'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'i'));
      await tester.tap(find.widgetWithText(OutlinedButton, 'i'));
      await tester.pumpAndSettle();
      expect(controller.text, '书ni');
      await tester.ensureVisible(find.byTooltip('Delete character'));
      await tester.tap(find.byTooltip('Delete character'));
      await tester.pumpAndSettle();
      expect(controller.text, '书n');
      await tester.tap(find.byTooltip('Delete character'));
      await tester.pumpAndSettle();
      expect(controller.text, '书');
      update(() => enabled = false);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(find.byKey(const ValueKey('answer')))
            .enabled,
        isFalse,
      );
      expect(
        tester
            .widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'n'))
            .onPressed,
        isNull,
      );
      expect(answer, '书');
      expect(tester.takeException(), isNull);
    },
  );
}
