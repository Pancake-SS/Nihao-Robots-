import 'dart:convert';

/// Structural validation only. Review declarations must still be checked by
/// the curator; this parser cannot establish language accuracy or reuse rights.
class VocabularyPack {
  VocabularyPack._(this.id, this.revision, List<VocabularyEntry> entries)
    : entries = List.unmodifiable(entries);

  final String id;
  final int revision;
  final List<VocabularyEntry> entries;

  factory VocabularyPack.parse(String input) {
    if (input.length > 1000000)
      throw const FormatException('Pack is too large.');
    Object? decoded;
    try {
      decoded = jsonDecode(input);
    } on FormatException {
      throw const FormatException('Pack must contain valid JSON.');
    }
    final pack = _record(decoded, {'schemaVersion', 'id', 'revision', 'words'});
    if (pack['schemaVersion'] is! int || pack['schemaVersion'] != 1) {
      throw const FormatException('Unsupported content schema.');
    }
    final revision = pack['revision'];
    if (revision is! int || revision < 1 || revision > 2147483647) {
      throw const FormatException('Invalid content revision.');
    }
    final words = pack['words'];
    if (words is! List || words.isEmpty || words.length > 50) {
      throw const FormatException('A starter pack requires 1 to 50 words.');
    }
    final ids = <String>{};
    final entries = <VocabularyEntry>[];
    for (final value in words) {
      final word = _record(value, {
        'id',
        'hanzi',
        'pinyin',
        'meaning',
        'examples',
        'source',
        'license',
        'reviewedBy',
        'reviewedOn',
        'reviewStatus',
        'audio',
      });
      final id = _id(word['id']);
      if (!ids.add(id)) throw const FormatException('Duplicate word ID.');
      if (word['reviewStatus'] != 'approved') {
        throw const FormatException('Word review is incomplete.');
      }
      // Audio import/playback needs a separate reviewed implementation.
      if (word['audio'] != null) {
        throw const FormatException('Audio import is not supported yet.');
      }
      final date = _text(word, 'reviewedOn', 10);
      final parsed = DateTime.tryParse(date);
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) ||
          parsed == null ||
          parsed.toIso8601String().substring(0, 10) != date) {
        throw const FormatException('Invalid review date.');
      }
      final examples = word['examples'];
      if (examples is! List || examples.length != 5) {
        throw const FormatException(
          'Each word requires exactly five examples.',
        );
      }
      final sentences = <String>{};
      final checkedExamples = <VocabularyExample>[];
      for (final value in examples) {
        final example = _record(value, {'hanzi', 'pinyin', 'meaning'});
        final hanzi = _text(example, 'hanzi', 500);
        if (!sentences.add(hanzi)) {
          throw const FormatException('Repeated example sentence.');
        }
        checkedExamples.add(
          VocabularyExample._(
            hanzi,
            _text(example, 'pinyin', 1000),
            _text(example, 'meaning', 1000),
          ),
        );
      }
      entries.add(
        VocabularyEntry._(
          id,
          _text(word, 'hanzi', 100),
          _text(word, 'pinyin', 300),
          _text(word, 'meaning', 1000),
          checkedExamples,
          _text(word, 'source', 2000),
          _text(word, 'license', 1000),
          _text(word, 'reviewedBy', 300),
          date,
        ),
      );
    }
    return VocabularyPack._(_id(pack['id']), revision, entries);
  }
}

class VocabularyEntry {
  VocabularyEntry._(
    this.id,
    this.hanzi,
    this.pinyin,
    this.meaning,
    List<VocabularyExample> examples,
    this.source,
    this.license,
    this.reviewedBy,
    this.reviewedOn,
  ) : examples = List.unmodifiable(examples);
  final String id, hanzi, pinyin, meaning;
  final List<VocabularyExample> examples;
  // These declarations cover the word and all five examples as one review unit.
  final String source, license, reviewedBy, reviewedOn;
}

class VocabularyExample {
  const VocabularyExample._(this.hanzi, this.pinyin, this.meaning);
  final String hanzi, pinyin, meaning;
}

Map<String, dynamic> _record(Object? value, Set<String> fields) {
  if (value is! Map<String, dynamic> ||
      value.length != fields.length ||
      !fields.every(value.containsKey)) {
    throw const FormatException('Missing or unknown content fields.');
  }
  return value;
}

String _text(Map<String, dynamic> value, String field, int limit) {
  final text = value[field];
  if (text is! String ||
      text.trim().isEmpty ||
      text.length > limit ||
      RegExp(r'[\x00-\x1F\x7F-\x9F\u200B\u202A-\u202E\u2066-\u2069\uFEFF]')
          .hasMatch(text)) {
    throw FormatException('Invalid $field field.');
  }
  return text.trim();
}

String _id(Object? value) {
  if (value is! String ||
      value.length > 100 ||
      !RegExp(r'^[a-z0-9]+(?:[._-][a-z0-9]+)*$').hasMatch(value)) {
    throw const FormatException('Invalid stable content ID.');
  }
  return value;
}
