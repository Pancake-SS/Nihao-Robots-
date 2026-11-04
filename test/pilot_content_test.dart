import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/vocabulary/content_pack.dart';

import 'pilot_fixture.dart';

void main() {
  Map<String, dynamic> source() => jsonDecode(
    File('assets/content/starter_greeting_v1.json').readAsStringSync(),
  );

  test('pilot has five examples, two reviewed recognition tasks and explicit review limits', () {
    final word = loadPilot().entry;
    expect(word.hanzi, '你好');
    expect(word.examples, hasLength(5));
    expect(word.questions.map((q) => q.kind), ['meaning', 'hanzi']);
    expect(word.reviewStatus, 'source-checked-pilot');
    expect(word.reviewedBy, contains('teacher review pending'));
    expect(word.questions.map((q) => q.options[q.correctOptionId]), [
      'Hello',
      '你好',
    ]);
    expect(() => word.questions.clear(), throwsUnsupportedError);
    expect(() => word.questions.first.options.clear(), throwsUnsupportedError);
  });

  test('schema 2 rejects malformed questions and incomplete review', () {
    for (final mutate in <void Function(Map<String, dynamic>)>[
      (p) => p['words'][0]['questions'].removeLast(),
      (p) => p['words'][0]['questions'][1]['id'] =
          p['words'][0]['questions'][0]['id'],
      (p) => p['words'][0]['questions'][1]['kind'] = 'meaning',
      (p) => p['words'][0]['questions'][0]['kind'] = 'audio',
      (p) => p['words'][0]['questions'][0]['options'].removeLast(),
      (p) => p['words'][0]['questions'][0]['options'][0]['id'] = 'hello',
      (p) => p['words'][0]['questions'][0]['options'][0]['text'] = 'Hello',
      (p) => p['words'][0]['questions'][0]['correctOptionId'] = 'absent',
      (p) => p['words'][0]['questions'][0]['prompt'] = '',
      (p) => p['words'][0]['reviewStatus'] = 'draft',
      (p) => p['words'][0]['questions'][0]['unknown'] = true,
    ]) {
      final pack = source();
      mutate(pack);
      expect(
        () => VocabularyPack.parse(jsonEncode(pack)),
        throwsFormatException,
      );
    }
  });
}
