import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/vocabulary/content_pack.dart';

// Synthetic parser data only. These strings are not a language lesson or a
// declaration that any reviewer has approved production curriculum.
Map<String, Object?> fixture() => {
  'schemaVersion': 1,
  'id': 'test.pack',
  'revision': 1,
  'words': [word('test.sense.1')],
};

Map<String, Object?> word(String id) => {
  'id': id,
  'hanzi': '测试',
  'pinyin': 'cèshì',
  'meaning': 'test fixture',
  'examples': List.generate(
    5,
    (i) => {'hanzi': '测试$i', 'pinyin': 'synthetic $i', 'meaning': 'fixture $i'},
  ),
  'source': 'Synthetic unit-test fixture, including all examples',
  'license': 'Test data only',
  'reviewedBy': 'Synthetic test reviewer',
  'reviewedOn': '2026-11-04',
  'reviewStatus': 'approved',
  'audio': null,
};

void main() {
  test('preserves Unicode and stable senses in immutable records', () {
    final input = fixture();
    (input['words'] as List).add(word('test.sense.2'));
    final pack = VocabularyPack.parse(jsonEncode(input));
    expect(pack.entries.map((w) => w.id), ['test.sense.1', 'test.sense.2']);
    expect(pack.entries.first.pinyin, 'cèshì');
    expect(pack.entries.first.examples.length, 5);
    expect(() => pack.entries.clear(), throwsUnsupportedError);
    expect(() => pack.entries.first.examples.clear(), throwsUnsupportedError);
  });

  test('rejects malformed, oversized and incompatible envelopes', () {
    for (final input in ['{', '[]', 'null', 'x' * 1000001]) {
      expect(() => VocabularyPack.parse(input), throwsFormatException);
    }
    for (final changes in [
      {'schemaVersion': 2},
      {'schemaVersion': 1.0},
      {'revision': 0},
      {'revision': '1'},
      {'words': []},
      {'words': List.generate(51, (i) => word('test.$i'))},
      {'id': '../path'},
      {'unexpected': true},
    ]) {
      expect(
        () => VocabularyPack.parse(jsonEncode({...fixture(), ...changes})),
        throwsFormatException,
      );
    }
  });

  test(
    'rejects duplicate IDs while allowing separate senses of the same Hanzi',
    () {
      final input = fixture();
      (input['words'] as List).add(word('test.sense.1'));
      expect(
        () => VocabularyPack.parse(jsonEncode(input)),
        throwsFormatException,
      );
    },
  );

  test('requires exactly five distinct complete examples', () {
    for (final count in [0, 4, 6]) {
      final input = fixture();
      final first = (input['words'] as List).first as Map;
      first['examples'] = List.generate(
        count,
        (i) => {'hanzi': '$i', 'pinyin': '$i', 'meaning': '$i'},
      );
      expect(
        () => VocabularyPack.parse(jsonEncode(input)),
        throwsFormatException,
      );
    }
    for (final invalid in [
      {'hanzi': '测试1', 'pinyin': 'test', 'meaning': 'duplicate'},
      {'hanzi': 'unique', 'pinyin': '', 'meaning': 'missing'},
      {'hanzi': 'unique', 'meaning': 'missing field'},
    ]) {
      final input = fixture();
      (((input['words'] as List).first as Map)['examples'] as List)[0] =
          invalid;
      expect(
        () => VocabularyPack.parse(jsonEncode(input)),
        throwsFormatException,
      );
    }
  });

  test('requires provenance, declared review and supported audio state', () {
    for (final change in [
      {'source': ' '},
      {'license': ''},
      {'reviewedBy': ''},
      {'reviewStatus': 'draft'},
      {'reviewedOn': '2026-02-30'},
      {'reviewedOn': '2026-1-1'},
      {'audio': 'https://example.invalid/audio'},
      {'meaning': 'hidden\u202Etext'},
      {'hanzi': 123},
    ]) {
      final input = fixture();
      ((input['words'] as List).first as Map).addAll(change);
      expect(
        () => VocabularyPack.parse(jsonEncode(input)),
        throwsFormatException,
      );
    }
  });
}
