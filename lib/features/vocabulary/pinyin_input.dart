import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'word_library.dart';

class PinyinCandidate {
  const PinyinCandidate(
    this.hanzi,
    this.pinyin,
    this.meaning, {
    this.sourceWord,
  });
  final String hanzi, pinyin, meaning;
  final String? sourceWord;
}

class PinyinSplit {
  const PinyinSplit(
    this.firstSyllable,
    this.remaining,
    this.rawPrefixLength,
    this.candidates,
  );
  final String firstSyllable, remaining;
  final int rawPrefixLength;
  final List<PinyinCandidate> candidates;
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
        _indexCharacters(word, reading, i < marked.length ? marked[i] : '');
      }
    }
  }

  final _index = <String, List<PinyinCandidate>>{};
  final _characters = <String, List<PinyinCandidate>>{};

  void _indexCharacters(DictionaryWord word, String reading, String marked) {
    final hanzi = word.hanzi.runes.map(String.fromCharCode).toList();
    final syllables = RegExp(r'[a-züv:]+[1-5]')
        .allMatches(reading.toLowerCase())
        .map((match) => match.group(0)!)
        .toList();
    if (hanzi.length != syllables.length ||
        hanzi.any(
          (character) => !RegExp(r'^[\u3400-\u9fff]$').hasMatch(character),
        )) {
      return;
    }
    final compactMarked = marked.replaceAll(RegExp(r"[\s'’·-]"), '');
    final lengths = syllables.map((syllable) => syllable.length - 1).toList();
    final markedMatches =
        compactMarked.length ==
        lengths.fold<int>(0, (length, next) => length + next);
    var cursor = 0;
    for (var i = 0; i < hanzi.length; i++) {
      final key = normalize(syllables[i]);
      if (key.isEmpty) continue;
      final characterPinyin = markedMatches
          ? compactMarked.substring(cursor, cursor + lengths[i])
          : syllables[i].substring(0, syllables[i].length - 1);
      cursor += lengths[i];
      final entries = _characters.putIfAbsent(key, () => []);
      if (entries.any((candidate) => candidate.hanzi == hanzi[i])) continue;
      entries.add(
        PinyinCandidate(
          hanzi[i],
          characterPinyin,
          hanzi.length == 1
              ? word.meaning
              : 'Character in ${word.hanzi} (${word.meaning})',
          sourceWord: hanzi.length == 1 ? null : word.hanzi,
        ),
      );
    }
  }

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
    // Characters attested inside dictionary words allow composition of words
    // absent from this particular word list, such as 冰 + 柜 from 柜子.
    add(_characters[query] ?? []);
    // Exact words first, followed by prefix completions in curriculum order.
    for (final entry in _index.entries) {
      if (entry.key != query && entry.key.startsWith(query)) add(entry.value);
      if (matches.length >= offset + limit) break;
    }
    return List.unmodifiable(matches.skip(offset).take(limit));
  }

  /// When a whole phrase is absent, offer its first attested character and
  /// leave the remaining Pinyin in the editor for the next selection.
  PinyinSplit? firstSyllable(String input, {int limit = 8}) {
    if (limit < 1 || limit > 20) throw ArgumentError('Invalid candidate limit');
    final query = normalize(input);
    if (query.length < 2) return null;
    for (var length = query.length - 1; length > 0; length--) {
      final prefix = query.substring(0, length);
      final remaining = query.substring(length);
      final characters = _characters[prefix];
      if (characters == null ||
          characters.isEmpty ||
          candidates(remaining, limit: 1).isEmpty) {
        continue;
      }
      for (var split = input.length - 1; split > 0; split--) {
        if (normalize(input.substring(0, split)) == prefix &&
            normalize(input.substring(split)) == remaining) {
          return PinyinSplit(
            prefix,
            remaining,
            split,
            List.unmodifiable(characters.take(limit)),
          );
        }
      }
    }
    return null;
  }
}

final pinyinInputEngineProvider = FutureProvider<PinyinInputEngine>(
  (ref) async =>
      PinyinInputEngine((await ref.watch(wordLibraryProvider.future)).words),
  retry: (_, _) => null,
);
