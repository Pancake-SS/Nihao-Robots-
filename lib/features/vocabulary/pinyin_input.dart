import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'word_library.dart';

class PinyinCandidate {
  const PinyinCandidate(this.hanzi, this.pinyin, this.meaning);
  final String hanzi, pinyin, meaning;
}

/// An offline curriculum lexicon, independent of the current quiz or answer.
class PinyinInputEngine {
  PinyinInputEngine(Iterable<DictionaryWord> words) {
    for (final word in words) {
      final numbered = word.pinyinNumbered.split('/');
      final marked = word.pinyin.split('/');
      for (var i = 0; i < numbered.length; i++) {
        final reading = numbered[i];
        final key = normalize(reading);
        if (key.isEmpty) continue;
        final entries = _index.putIfAbsent(key, () => []);
        if (!entries.any((candidate) => candidate.hanzi == word.hanzi)) {
          entries.add(
            PinyinCandidate(
              word.hanzi,
              i < marked.length ? marked[i].trim() : word.pinyin,
              word.meaning,
            ),
          );
        }
      }
    }
  }

  final _index = <String, List<PinyinCandidate>>{};

  static String normalize(String value) {
    value = value.toLowerCase().replaceAll('u:', 'v');
    const groups = {
      'a': 'āáǎà',
      'e': 'ēéěè',
      'i': 'īíǐì',
      'o': 'ōóǒò',
      'u': 'ūúǔù',
      'v': 'üǖǘǚǜ',
    };
    for (final group in groups.entries) {
      for (final character in group.value.split('')) {
        value = value.replaceAll(character, group.key);
      }
    }
    value = value.replaceAll(RegExp(r"[1-5\s'’·-]"), '');
    return RegExp(r'^[a-z]{1,60}$').hasMatch(value) ? value : '';
  }

  List<PinyinCandidate> candidates(
    String input, {
    int offset = 0,
    int limit = 8,
  }) {
    if (offset < 0 || limit < 1 || limit > 20)
      throw ArgumentError('Invalid candidate page');
    final query = normalize(input);
    if (query.isEmpty) return const [];
    final matches = <PinyinCandidate>[];
    final seen = <String>{};
    void add(Iterable<PinyinCandidate> values) {
      for (final value in values) {
        if (seen.add(value.hanzi)) matches.add(value);
      }
    }

    add(_index[query] ?? []);
    // Exact words first, followed by prefix completions in curriculum order.
    for (final entry in _index.entries) {
      if (entry.key != query && entry.key.startsWith(query)) add(entry.value);
      if (matches.length >= offset + limit) break;
    }
    return List.unmodifiable(matches.skip(offset).take(limit));
  }
}

final pinyinInputEngineProvider = FutureProvider<PinyinInputEngine>(
  (ref) async =>
      PinyinInputEngine((await ref.watch(wordLibraryProvider.future)).words),
  retry: (_, _) => null,
);
