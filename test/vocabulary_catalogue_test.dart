import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_catalogue_screen.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';

import 'content_pack_fixture.dart';

class _Bundle extends CachingAssetBundle {
  _Bundle(this.files);
  final Map<String, String> files;
  @override
  Future<ByteData> load(String key) async =>
      throw UnsupportedError('No binary fixtures');
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (!files.containsKey(key)) throw StateError('Missing test asset');
    return files[key]!;
  }
}

class _DelayedRepository implements VocabularyRepository {
  final gate = Completer<List<CatalogueWord>>();
  bool retry = false;
  @override
  Future<List<CatalogueWord>> load() =>
      retry ? Future.value(const []) : gate.future;
}

Future<void> _mount(
  WidgetTester tester,
  VocabularyRepository repository, {
  bool pinyin = true,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [vocabularyRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        theme: buildTheme(),
        home: VocabularyCatalogueScreen(showPinyin: pinyin, profileId: 1),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  test(
    'loads an immutable catalogue with pack revision and stable word identity',
    () async {
      final pack = fixture()..['revision'] = 3;
      final repository = BundledVocabularyRepository(
        _Bundle({'a': jsonEncode(pack)}),
        ['a'],
      );
      final words = await repository.load();
      expect(words.single.packId, 'test.pack');
      expect(words.single.revision, 3);
      expect(words.single.entry.id, 'test.sense.1');
      expect(() => words.clear(), throwsUnsupportedError);
    },
  );

  test(
    'rejects missing, invalid and conflicting packs without partial results',
    () async {
      final first = jsonEncode(fixture());
      final another = fixture()..['id'] = 'other.pack';
      for (final second in [null, '{', first, jsonEncode(another)]) {
        final repository = BundledVocabularyRepository(
          _Bundle({'a': first, if (second != null) 'b': second}),
          ['a', 'b'],
        );
        await expectLater(
          repository.load(),
          second == null ? throwsStateError : throwsFormatException,
        );
      }
    },
  );

  testWidgets(
    'empty production catalogue explains availability without fake rows',
    (tester) async {
      await _mount(tester, BundledVocabularyRepository(_Bundle({}), []));
      await tester.pumpAndSettle();
      expect(find.text('Your first words are on their way'), findsOneWidget);
      expect(find.text('Explore word'), findsNothing);
    },
  );

  testWidgets('loading then failed read offers an explicit working retry', (
    tester,
  ) async {
    final repository = _DelayedRepository();
    await _mount(tester, repository);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.gate.completeError(StateError('Test read failure'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('saved progress has not changed'),
      findsOneWidget,
    );
    repository.retry = true;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Your first words are on their way'), findsOneWidget);
  });

  for (final pinyin in [true, false]) {
    testWidgets(
      'catalogue to five-example lesson, Pinyin=$pinyin, narrow large text',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await _mount(
          tester,
          BundledVocabularyRepository(_Bundle({'a': jsonEncode(fixture())}), [
            'a',
          ]),
          pinyin: pinyin,
        );
        await tester.pumpAndSettle();
        expect(find.text('cèshì'), pinyin ? findsOneWidget : findsNothing);
        await tester.ensureVisible(find.text('Explore word'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Explore word'));
        await tester.pumpAndSettle();
        expect(find.text('Meet a word'), findsOneWidget);
        expect(find.text('Play word'), findsOneWidget);
        for (var i = 0; i < 5; i++) {
          final example = find.byKey(ValueKey('word-example-$i'));
          await tester.ensureVisible(example);
          expect(
            find.text('synthetic $i'),
            pinyin ? findsOneWidget : findsNothing,
          );
        }
        expect(find.text('Example 6'), findsNothing);
        await tester.ensureVisible(find.text('Content source and review'));
        await tester.tap(find.text('Content source and review'));
        await tester.pumpAndSettle();
        expect(find.text('Content revision: 1'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('Learn a word'), findsOneWidget);
      },
    );
  }
}
