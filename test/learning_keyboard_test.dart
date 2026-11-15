import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/vocabulary/add_word_screen.dart';
import 'package:ni_hao_robot/features/vocabulary/learning_keyboard.dart';
import 'package:ni_hao_robot/features/vocabulary/pinyin_input.dart';
import 'package:ni_hao_robot/features/vocabulary/word_library.dart';

void main() {
  late PinyinInputEngine engine;
  setUpAll(() {
    engine = PinyinInputEngine(
      WordLibrary.parse(
        File('assets/content/dictionary_v1.json').readAsStringSync(),
      ).words,
    );
  });

  testWidgets(
    'four modes edit their fields and All fills a one-line dictionary choice',
    (tester) async {
      final hanzi = TextEditingController();
      final pinyin = TextEditingController();
      final english = TextEditingController();
      addTearDown(() {
        hanzi.dispose();
        pinyin.dispose();
        english.dispose();
      });
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pinyinInputEngineProvider.overrideWith((ref) async => engine),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ListView(
                children: [
                  LearningKeyboard(
                    hanzi: hanzi,
                    pinyin: pinyin,
                    english: english,
                    enabled: true,
                    hanziKey: const ValueKey('hanzi-field'),
                    pinyinKey: const ValueKey('pinyin-field'),
                    englishKey: const ValueKey('english-field'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final mode in LearningKeyboardMode.values) {
        expect(find.byKey(ValueKey('mode-${mode.name}')), findsOneWidget);
      }
      await tester.tap(find.byKey(const ValueKey('mode-all')));
      await tester.enterText(
        find.byKey(const ValueKey('hanzi-field')),
        'nihao',
      );
      await tester.pumpAndSettle();
      final candidate = engine.candidates('nihao').first;
      expect(
        find.textContaining('${candidate.hanzi} · ${candidate.pinyin} ·'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(ValueKey('candidate-${candidate.hanzi}')));
      await tester.pumpAndSettle();
      expect(hanzi.text, candidate.hanzi);
      expect(pinyin.text, candidate.pinyin);
      expect(
        english.text,
        candidate.meaning.split(RegExp(r'[;/]')).first.trim(),
      );
      expect(
        tester
            .widget<Text>(find.byKey(const ValueKey('combined-preview')))
            .data,
        '${candidate.hanzi} · ${candidate.pinyin} · ${english.text}',
      );

      await tester.tap(find.byKey(const ValueKey('mode-pinyin')));
      await tester.enterText(
        find.byKey(const ValueKey('pinyin-field')),
        'nihao',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('candidate-${candidate.hanzi}')));
      expect(pinyin.text, candidate.pinyin);

      await tester.tap(find.byKey(const ValueKey('mode-english')));
      await tester.enterText(
        find.byKey(const ValueKey('english-field')),
        'hello there',
      );
      expect(english.text, 'hello there');

      await tester.tap(find.byKey(const ValueKey('mode-hanzi')));
      await tester.enterText(
        find.byKey(const ValueKey('hanzi-field')),
        'nihao',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('candidate-${candidate.hanzi}')));
      expect(hanzi.text, candidate.hanzi);
      await tester.enterText(
        find.byKey(const ValueKey('hanzi-field')),
        'nihao ',
      );
      await tester.pumpAndSettle();
      expect(
        hanzi.text,
        candidate.hanzi,
        reason: 'Space accepts the inline Hanzi candidate',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'pasted sentence text survives scrolling through all five examples',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pinyinInputEngineProvider.overrideWith((ref) async => engine),
          ],
          child: const MaterialApp(
            home: AddWordExamplesScreen(
              profileId: 1,
              hanzi: '你好',
              pinyin: 'nǐ hǎo',
              meaning: 'hello',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('custom-example-hanzi-0')),
        '你好，我来了。',
      );
      await tester.enterText(
        find.byKey(const ValueKey('custom-example-pinyin-0')),
        'Nǐ hǎo, wǒ lái le.',
      );
      await tester.enterText(
        find.byKey(const ValueKey('custom-example-english-0')),
        'Hello, I have arrived.',
      );
      await tester.tap(find.byKey(const ValueKey('mode-all')));
      final scrollable = find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text('Sentence 5'),
        450,
        scrollable: scrollable,
        maxScrolls: 30,
      );
      await tester.pumpAndSettle();
      expect(find.text('Sentence 5'), findsOneWidget);
      expect(
        tester
            .widget<ChoiceChip>(find.byKey(const ValueKey('mode-all')).last)
            .selected,
        isTrue,
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey('custom-example-hanzi-4')),
      );
      await tester.enterText(
        find.byKey(const ValueKey('custom-example-hanzi-4')),
        '你好，这里还有一句。',
      );
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('custom-example-hanzi-0')),
        -450,
        scrollable: scrollable,
        maxScrolls: 30,
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('custom-example-hanzi-0')),
            )
            .controller!
            .text,
        '你好，我来了。',
      );
      expect(
        tester
            .widget<TextField>(
              find.byKey(const ValueKey('custom-example-pinyin-0')),
            )
            .controller!
            .text,
        'Nǐ hǎo, wǒ lái le.',
      );
      expect(
        tester
            .widget<TextField>(
              find.byKey(const ValueKey('custom-example-english-0')),
            )
            .controller!
            .text,
        'Hello, I have arrived.',
      );
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('custom-example-hanzi-4')),
        450,
        scrollable: scrollable,
        maxScrolls: 30,
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('custom-example-hanzi-4')),
            )
            .controller!
            .text,
        '你好，这里还有一句。',
      );
      expect(tester.takeException(), isNull);
    },
  );
}
