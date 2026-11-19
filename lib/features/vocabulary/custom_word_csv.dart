import 'custom_word.dart';
import 'pinyin_input.dart';

/// A portable, one-row-per-word format for learner-supplied lessons.
/// Quotes, escaped quotes, commas and CRLF follow ordinary CSV rules.
class CustomWordCsv {
  static const maxWords = 20;
  static const maxCharacters = 250000;

  static const columns = <String>[
    'hanzi',
    'pinyin',
    'meaning',
    'sentence1_hanzi',
    'sentence1_pinyin',
    'sentence1_english',
    'sentence2_hanzi',
    'sentence2_pinyin',
    'sentence2_english',
    'sentence3_hanzi',
    'sentence3_pinyin',
    'sentence3_english',
    'sentence4_hanzi',
    'sentence4_pinyin',
    'sentence4_english',
    'sentence5_hanzi',
    'sentence5_pinyin',
    'sentence5_english',
    'explanation',
  ];

  static String get header => columns.join(',');

  static String chatGptPrompt(String requestedWords) {
    final target = requestedWords.trim().isEmpty
        ? '[the Chinese word or words I specify]'
        : requestedWords.trim();
    return '''Create a UTF-8 CSV for these Chinese words: $target

Return ONLY CSV text. Do not add Markdown fences, an introduction, or notes outside the CSV.
Use this exact header in this exact order:
$header

Write one row for each word, at most $maxWords rows. Use Simplified Chinese Hanzi, tone-marked Pinyin, and an accurate English meaning. For each word, write five different natural Chinese sentences. Every Chinese sentence must contain that exact Hanzi word, and each sentence needs its own tone-marked Pinyin and faithful English translation. The explanation column is optional and should be short English teaching guidance; leave it empty if unsure. Quote any CSV field containing a comma, a quote, or a newline; double quotes inside a quoted field. Do not invent a source or claim a teacher checked the content. If you cannot verify a word or translation, say so outside the CSV instead of guessing. I will review the result before importing.''';
  }

  static List<CustomWordDraft> parse(String input) {
    if (input.length > maxCharacters) {
      throw const FormatException(
        'The CSV is too large. Import at most 20 words at a time.',
      );
    }
    var source = input.trim();
    if (source.startsWith('\uFEFF')) source = source.substring(1);
    // ChatGPT sometimes wraps otherwise valid CSV in a single code fence.
    if (source.startsWith('```')) {
      final firstLine = source.indexOf('\n');
      if (firstLine < 0 || !source.endsWith('```')) {
        throw const FormatException(
          'Paste CSV text, without surrounding notes.',
        );
      }
      source = source.substring(firstLine + 1, source.length - 3).trim();
    }
    if (source.isEmpty) throw const FormatException('Paste CSV text first.');

    final rows = _readRows(source);
    if (rows.length < 2) {
      throw const FormatException(
        'Include the header and at least one word row.',
      );
    }
    final expected = columns.take(rows.first.length).toList();
    if ((rows.first.length != 18 && rows.first.length != 19) ||
        !_sameHeader(rows.first, expected)) {
      throw const FormatException(
        'The CSV header does not match the template. Copy the template or AI prompt first.',
      );
    }
    if (rows.length - 1 > maxWords) {
      throw const FormatException('Import at most 20 words at a time.');
    }

    final drafts = <CustomWordDraft>[];
    final seenHanzi = <String, int>{};
    final seenPinyin = <String, int>{};
    final seenMeaning = <String, int>{};
    for (var i = 1; i < rows.length; i++) {
      final values = rows[i].map((value) => value.trim()).toList();
      if (values.length != rows.first.length) {
        throw FormatException(
          'Word row ${i + 1} has ${values.length} columns; expected ${rows.first.length}.',
        );
      }
      final draft = CustomWordDraft(
        hanzi: values[0],
        pinyin: values[1],
        meaning: values[2],
        examples: [
          for (var n = 0; n < 5; n++)
            CustomSentence(
              values[3 + n * 3],
              values[4 + n * 3],
              values[5 + n * 3],
            ),
        ],
        explanation: values.length == 19 ? values[18] : '',
        imported: true,
      );
      try {
        draft.validate();
      } on FormatException catch (error) {
        throw FormatException('Word row ${i + 1}: ${error.message}');
      }
      for (final entry in [
        (seenHanzi, draft.hanzi, 'Hanzi'),
        (seenPinyin, PinyinInputEngine.normalize(draft.pinyin), 'Pinyin'),
        (seenMeaning, draft.meaning.toLowerCase(), 'English meaning'),
      ]) {
        final previous = entry.$1[entry.$2];
        if (previous != null) {
          throw FormatException(
            'Word rows $previous and ${i + 1} share ${entry.$3}.',
          );
        }
        entry.$1[entry.$2] = i + 1;
      }
      drafts.add(draft);
    }
    return List.unmodifiable(drafts);
  }

  static bool _sameHeader(List<String> actual, List<String> expected) {
    for (var i = 0; i < expected.length; i++) {
      if (actual[i].trim().toLowerCase() != expected[i]) return false;
    }
    return true;
  }

  static List<List<String>> _readRows(String source) {
    final runes = source.runes.toList();
    final rows = <List<String>>[];
    var row = <String>[];
    var field = StringBuffer();
    var state = 0; // 0 start, 1 plain, 2 quoted, 3 after closing quote.
    var line = 1;

    void endField() {
      row.add(field.toString());
      field = StringBuffer();
      state = 0;
    }

    void endRow() {
      endField();
      if (row.any((value) => value.trim().isNotEmpty)) rows.add(row);
      row = <String>[];
    }

    for (var i = 0; i < runes.length; i++) {
      final rune = runes[i];
      if (state == 2) {
        if (rune == 34) {
          state = 3;
        } else if (rune == 13 || rune == 10) {
          field.write('\n');
          if (rune == 13 && i + 1 < runes.length && runes[i + 1] == 10) i++;
          line++;
        } else {
          field.writeCharCode(rune);
        }
        continue;
      }
      if (rune == 44) {
        endField();
      } else if (rune == 13 || rune == 10) {
        endRow();
        if (rune == 13 && i + 1 < runes.length && runes[i + 1] == 10) i++;
        line++;
      } else if (rune == 34) {
        if (state == 0) {
          state = 2;
        } else if (state == 3) {
          field.write('"');
          state = 2;
        } else {
          throw FormatException('Unexpected quote on CSV line $line.');
        }
      } else if (state == 3) {
        throw FormatException(
          'Unexpected text after a closing quote on CSV line $line.',
        );
      } else {
        field.writeCharCode(rune);
        state = 1;
      }
    }
    if (state == 2)
      throw const FormatException('A quoted CSV field is not closed.');
    if (row.isNotEmpty || field.isNotEmpty || state == 3) endRow();
    return rows;
  }
}
