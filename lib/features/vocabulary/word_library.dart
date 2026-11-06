import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'learning_priority.dart';

class DictionaryWord {
  const DictionaryWord(
    this.id,
    this.hanzi,
    this.traditional,
    this.pinyin,
    this.pinyinNumbered,
    this.meaning,
    this.partOfSpeech,
    this.band,
    this.priority,
  );
  final String id,
      hanzi,
      traditional,
      pinyin,
      pinyinNumbered,
      meaning,
      partOfSpeech;
  final int? band;
  final LearningPriority priority;

  bool matches(String query) {
    query = query.trim().toLowerCase();
    return [
      hanzi,
      traditional,
      pinyin,
      pinyinNumbered,
      meaning,
      pinyinNumbered.replaceAll(RegExp(r'[1-5\s]'), ''),
    ].any((value) => value.toLowerCase().contains(query));
  }
}

class WordLibrary {
  WordLibrary._(this.version, List<DictionaryWord> words)
    : words = List.unmodifiable(words);
  final String version;
  final List<DictionaryWord> words;

  static String _text(Map value, String key, int limit) {
    final text = value[key];
    if (text is! String ||
        text.trim().isEmpty ||
        text.length > limit ||
        RegExp(r'[\x00-\x1f\x7f-\x9f\u200b\u202a-\u202e\u2066-\u2069\ufeff]')
            .hasMatch(text)) {
      throw const FormatException('Invalid dictionary text.');
    }
    return text.trim();
  }

  factory WordLibrary.parse(String input) {
    if (input.length > 15000000)
      throw const FormatException('Dictionary is too large.');
    final value = jsonDecode(input);
    if (value is! Map ||
        value['schemaVersion'] != 1 ||
        value['revision'] != 1 ||
        value['source'] is! Map ||
        value['words'] is! List) {
      throw const FormatException('Unsupported dictionary.');
    }
    final source = value['source'] as Map;
    if (source['license'] != 'CC BY 4.0' ||
        source['url'] !=
            'https://hearmandarin.com/datasets/hsk-3-0-words.json' ||
        source['sha256'] is! String ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(source['sha256'])) {
      throw const FormatException('Invalid dictionary provenance.');
    }
    final rows = value['words'] as List;
    if (rows.isEmpty || rows.length > 20000)
      throw const FormatException('Invalid dictionary size.');
    final seen = <String>{};
    final words = <DictionaryWord>[];
    for (final row in rows) {
      if (row is! Map) throw const FormatException('Invalid dictionary row.');
      final id = _text(row, 'id', 100);
      if (!RegExp(r'^hearmandarin\.w[0-9]+\.1$').hasMatch(id) ||
          !seen.add(id)) {
        throw const FormatException(
          'Invalid or duplicate dictionary identity.',
        );
      }
      final band = row['band'];
      if (band != null && (band is! int || band < 1 || band > 7)) {
        throw const FormatException('Invalid dictionary band.');
      }
      words.add(
        DictionaryWord(
          id,
          _text(row, 'hanzi', 100),
          _text(row, 'traditional', 100),
          _text(row, 'pinyin', 300),
          _text(row, 'pinyinNumbered', 300),
          _text(row, 'meaning', 1000),
          _text(row, 'partOfSpeech', 200),
          band as int?,
          LearningPriority.parse(row['learningPriority']),
        ),
      );
    }
    words.sort(
      (a, b) => LearningPriority.compare(
        a.priority,
        a.band,
        a.id,
        b.priority,
        b.band,
        b.id,
      ),
    );
    return WordLibrary._(_text(source, 'version', 100), words);
  }
}

final wordLibraryProvider = FutureProvider<WordLibrary>(
  (ref) async => WordLibrary.parse(
    await rootBundle.loadString('assets/content/dictionary_v1.json'),
  ),
  retry: (_, _) => null,
);
