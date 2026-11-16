import 'dart:math';

import '../vocabulary/content_pack.dart';
import '../vocabulary/vocabulary_repository.dart';

enum PracticeMode { singleWord, randomWords, endless }

class PracticeItem {
  const PracticeItem(this.wordId, this.question);
  final String wordId;
  final VocabularyQuestion question;
}

/// Builds practice questions from saved words. Finite random sessions use one
/// question per distinct word. Endless sessions never draw the same question
/// twice, and end naturally after the available question bank is exhausted.
class PracticeDeck {
  PracticeDeck({
    required this.mode,
    required Iterable<String> wordIds,
    this.count = 0,
    Random? random,
  }) : _random = random ?? Random(),
       _remainingWords = List.of(wordIds) {
    if (_remainingWords.isEmpty) throw ArgumentError('No learned words.');
    if (mode == PracticeMode.randomWords &&
        (count < 1 || count > _remainingWords.length)) {
      throw ArgumentError('Choose a count within your learned word total.');
    }
    _remainingWords.shuffle(_random);
    _remainingCount = count;
  }

  final PracticeMode mode;
  final int count;
  final Random _random;
  final List<String> _remainingWords;
  final Map<String, List<String>> _unusedQuestions = {};
  bool _finiteBuilt = false;
  late int _remainingCount;

  Future<List<PracticeItem>> nextBatch(
    Future<CatalogueWord?> Function(String) lookup, {
    int batchSize = 20,
  }) async {
    if (mode == PracticeMode.singleWord && _finiteBuilt) return const [];
    if (mode == PracticeMode.randomWords && _remainingCount == 0)
      return const [];
    if (mode == PracticeMode.singleWord) {
      _finiteBuilt = true;
      final word = await lookup(_remainingWords.single);
      if (word == null) return const [];
      return [
        for (final question in word.entry.questions)
          PracticeItem(word.entry.id, question),
      ];
    }
    final target = mode == PracticeMode.randomWords
        ? min(batchSize, _remainingCount)
        : batchSize;
    final items = <PracticeItem>[];
    while (items.length < target && _remainingWords.isNotEmpty) {
      final index = mode == PracticeMode.randomWords
          ? _remainingWords.length - 1
          : _random.nextInt(_remainingWords.length);
      final id = _remainingWords[index];
      final word = await lookup(id);
      if (word == null || word.entry.questions.isEmpty) {
        _remainingWords.removeAt(index);
        continue;
      }
      if (mode == PracticeMode.randomWords) {
        _remainingWords.removeAt(index);
        items.add(
          PracticeItem(
            id,
            word.entry.questions[_random.nextInt(word.entry.questions.length)],
          ),
        );
        _remainingCount--;
        continue;
      }
      final remaining = _unusedQuestions.putIfAbsent(
        id,
        () => [for (final question in word.entry.questions) question.id],
      );
      if (remaining.isEmpty) {
        _remainingWords.removeAt(index);
        continue;
      }
      final questionId = remaining.removeAt(_random.nextInt(remaining.length));
      final question = word.entry.questions
          .where((question) => question.id == questionId)
          .first;
      items.add(PracticeItem(id, question));
      if (remaining.isEmpty) {
        _unusedQuestions.remove(id);
        _remainingWords.removeAt(index);
      }
    }
    return items;
  }
}
