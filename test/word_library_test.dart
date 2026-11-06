import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/vocabulary/learning_priority.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/word_library.dart';
import 'package:ni_hao_robot/features/vocabulary/word_library_screen.dart';

import 'imported_fixture.dart';

void main() {
  final source = File('assets/content/dictionary_v1.json').readAsStringSync();
  final library = WordLibrary.parse(source);

  test('full imported dictionary preserves identity and orders basics before higher bands', () {
    expect(library.words, hasLength(11147));
    expect(library.words.map((w) => w.id).toSet(), hasLength(11147));
    expect(library.words.first.hanzi, '你好');
    expect(library.words.map((w) => w.priority.tier).toSet(), {0, 1, 2, 3, 4});
    for (var i = 1; i < library.words.length; i++) {
      final a = library.words[i - 1], b = library.words[i];
      expect(
        LearningPriority.compare(
          a.priority,
          a.band,
          a.id,
          b.priority,
          b.band,
          b.id,
        ),
        lessThanOrEqualTo(0),
      );
    }
    expect(
      library.words
          .where((w) => w.band == null)
          .every((w) => w.priority.tier == 4),
      isTrue,
    );
    final book = library.words.firstWhere((w) => w.hanzi == '书');
    for (final query in ['书', '書', 'shū', 'shu1', 'shu', 'book']) {
      expect(book.matches(query), isTrue);
    }
  });

  test(
    'invalid identity, priority and attribution reject the entire dictionary',
    () {
      final original = jsonDecode(source) as Map<String, dynamic>;
      original['words'] = (original['words'] as List).take(2).toList();
      for (final mutate in <void Function(Map<String, dynamic>)>[
        (v) => v['words'][1]['id'] = v['words'][0]['id'],
        (v) => v['words'][0]['learningPriority']['tier'] = -1,
        (v) => v['words'][0]['learningPriority']['order'] = 30000,
        (v) => v['words'][0]['meaning'] = '\u0000hidden',
        (v) => v['words'][0]['band'] = 100,
        (v) => v['source']['url'] = 'file:///private',
        (v) => v['source']['license'] = 'unknown',
      ]) {
        final changed =
            jsonDecode(jsonEncode(original)) as Map<String, dynamic>;
        mutate(changed);
        expect(
          () => WordLibrary.parse(jsonEncode(changed)),
          throwsFormatException,
        );
      }
    },
  );

  testWidgets(
    'library search offers an available lesson and priority filters remain usable at large text',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final lessons = await BundledVocabularyRepository(
        ContentTestBundle(),
        starterPaths,
      ).load();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            wordLibraryProvider.overrideWith((ref) async => library),
            vocabularyCatalogueProvider.overrideWith((ref) async => lessons),
          ],
          child: MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: const WordLibraryScreen(profileId: 1, showPinyin: true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('dictionary-search')),
        'shu1',
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('书'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('书'), findsOneWidget);
      expect(find.text('Open full lesson'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byType(DropdownButtonFormField<int>),
        -250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Advanced').last);
      await tester.tap(find.text('Advanced').last);
      await tester.pumpAndSettle();
      expect(find.text('书'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
