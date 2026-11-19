import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/vocabulary/custom_word_csv.dart';

List<String> _word(String hanzi, String pinyin, String meaning) => [
  hanzi,
  pinyin,
  meaning,
  for (var i = 1; i <= 5; i++) ...[
    '我喜欢$hanzi$i。',
    'Wǒ xǐhuan $pinyin $i.',
    'I like $meaning number $i.',
  ],
  'A short note, with a comma.',
];

String _row(List<String> values) =>
    values.map((value) => '"${value.replaceAll('"', '""')}"').join(',');

void main() {
  test('parses quoted CSV, Unicode, and multiple words in source order', () {
    final source = [
      CustomWordCsv.header,
      _row(_word('机器人咖啡馆', 'jī qì rén kā fēi guǎn', 'robot cafe')),
      _row(_word('机器人书店', 'jī qì rén shū diàn', 'robot bookshop')),
    ].join('\r\n');
    final result = CustomWordCsv.parse('```csv\n$source\n```');
    expect(result.map((word) => word.hanzi), ['机器人咖啡馆', '机器人书店']);
    expect(result.first.examples, hasLength(5));
    expect(result.first.explanation, 'A short note, with a comma.');
    expect(result.first.imported, isTrue);
    expect(
      CustomWordCsv.chatGptPrompt('robot cafe'),
      allOf(contains(CustomWordCsv.header), contains('robot cafe')),
    );
  });

  test('rejects malformed rows and duplicate word identities', () {
    final word = _word('机器人咖啡馆', 'jī qì rén kā fēi guǎn', 'robot cafe');
    expect(
      () => CustomWordCsv.parse(
        '${CustomWordCsv.header}\n${_row(word.take(12).toList())}',
      ),
      throwsA(isA<FormatException>()),
    );
    final missingWord = [...word]..[3] = '今天很好。';
    expect(
      () =>
          CustomWordCsv.parse('${CustomWordCsv.header}\n${_row(missingWord)}'),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => CustomWordCsv.parse(
        '${CustomWordCsv.header}\n${_row(word)}\n${_row(word)}',
      ),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => CustomWordCsv.parse('${CustomWordCsv.header}\n"unterminated'),
      throwsA(isA<FormatException>()),
    );
  });
}
