/// Learner-authored lessons. Examples and explanations are never labelled as
/// independently reviewed or attributed to an external dictionary.
class CustomSentence {
  const CustomSentence(this.hanzi, this.pinyin, this.meaning);
  final String hanzi, pinyin, meaning;
}

class CustomWordDraft {
  const CustomWordDraft({
    required this.hanzi,
    required this.pinyin,
    required this.meaning,
    required this.examples,
    this.explanation = '',
  });
  final String hanzi, pinyin, meaning, explanation;
  final List<CustomSentence> examples;

  static bool _safe(String text, int limit) =>
      text.trim().isNotEmpty &&
      text.length <= limit &&
      !RegExp(r'[\x00-\x1f\x7f-\x9f\u200b\u202a-\u202e\u2066-\u2069\ufeff]')
          .hasMatch(text);

  static void validateWord(String hanzi, String pinyin, String meaning) {
    if (!_safe(hanzi, 100) ||
        !RegExp(r'^[\u3400-\u9fff\uf900-\ufaff]+$').hasMatch(hanzi.trim())) {
      throw const FormatException('Enter a Simplified Chinese word in Hanzi.');
    }
    if (!_safe(pinyin, 300) ||
        !RegExp(r'[A-Za-z\u00c0-\u024f]').hasMatch(pinyin)) {
      throw const FormatException('Enter the word\'s Pinyin.');
    }
    if (!_safe(meaning, 1000) || !RegExp(r'[A-Za-z]').hasMatch(meaning)) {
      throw const FormatException('Enter an English meaning.');
    }
  }

  void validate() {
    validateWord(hanzi, pinyin, meaning);
    if (examples.length != 5) {
      throw const FormatException('Add five sentence examples.');
    }
    final distinct = <String>{};
    for (var i = 0; i < examples.length; i++) {
      final example = examples[i];
      if (!_safe(example.hanzi, 500) ||
          !example.hanzi.contains(hanzi.trim()) ||
          !RegExp(r'[\u3400-\u9fff\uf900-\ufaff]').hasMatch(example.hanzi)) {
        throw FormatException(
          'Example ${i + 1} needs a Chinese sentence using this word.',
        );
      }
      if (!distinct.add(example.hanzi.trim())) {
        throw const FormatException('Use five different Chinese sentences.');
      }
      if (!_safe(example.pinyin, 1000)) {
        throw FormatException('Add Pinyin for example ${i + 1}.');
      }
      if (!_safe(example.meaning, 1000) ||
          !RegExp(r'[A-Za-z]').hasMatch(example.meaning)) {
        throw FormatException(
          'Add an English translation for example ${i + 1}.',
        );
      }
    }
    if (explanation.isNotEmpty && !_safe(explanation, 2000)) {
      throw const FormatException(
        'Keep the optional explanation under 2,000 characters.',
      );
    }
  }
}

class CustomChoiceWord {
  const CustomChoiceWord(this.hanzi, this.pinyin, this.meaning);
  final String hanzi, pinyin, meaning;
}

/// The same core question patterns as imported lessons, with source-word
/// distractors selected from related meanings where possible.
class CustomWordQuestions {
  static String _firstMeaning(String value) => value
      .toLowerCase()
      .split(RegExp(r'[;/]'))
      .first
      .trim()
      .replaceFirst(RegExp(r'^(to|a|an|the)\s+'), '');

  static String category(String value) {
    final first = _firstMeaning(value);
    const countries = {
      'united states',
      'america',
      'usa',
      'china',
      'japan',
      'korea',
      'south korea',
      'north korea',
      'france',
      'germany',
      'russia',
      'india',
      'canada',
      'australia',
      'brazil',
      'england',
      'united kingdom',
      'britain',
      'italy',
      'spain',
      'singapore',
      'malaysia',
      'thailand',
      'vietnam',
    };
    if (countries.contains(first)) return 'country';
    const groups = <String, String>{
      'family': r'\b(father|mother|dad|mom|parent|brother|sister|son|daughter|grandfather|grandmother|grandpa|grandma|uncle|aunt|husband|wife|cousin)\b',
      'color': r'\b(red|blue|green|yellow|orange|purple|pink|black|white|brown|gray|grey|color|colour)\b',
      'fruit': r'\b(apple|banana|orange|pear|peach|grape|strawberry|watermelon|mango|pineapple|fruit)\b',
      'transport': r'\b(car|bus|train|subway|metro|airplane|plane|taxi|bicycle|bike|ship|boat|transport)\b',
      'time': r'\b(today|tomorrow|yesterday|morning|afternoon|evening|night|week|month|year|hour|minute|day)\b',
      'place': r'\b(country|nation|city|town|village|province|continent|island|river|mountain|sea|ocean)\b',
      'school': r'\b(teacher|student|school|classroom|classmate|lesson|homework|exam|university|college)\b',
      'food': r'\b(rice|noodle|bread|egg|meat|chicken|beef|pork|vegetable|soup|dumpling|food|meal)\b',
      'animal': r'\b(dog|cat|bird|fish|horse|cow|pig|sheep|rabbit|tiger|lion|bear|panda)\b',
      'drink':
          r'\b(water|tea|coffee|milk|juice|beer|wine|drink|beverage|cafe)\b',
      'body':
          r'\b(head|face|eye|ear|nose|mouth|hand|arm|leg|foot|heart|body)\b',
      'weather': r'\b(rain|snow|wind|sun|cloud|weather|storm|temperature)\b',
    };
    for (final group in groups.entries) {
      if (RegExp(group.value).hasMatch(value.toLowerCase())) return group.key;
    }
    return '';
  }

  static List<Map<String, Object?>> build(
    String id,
    CustomWordDraft draft,
    Iterable<CustomChoiceWord> source,
  ) {
    final related = category(draft.meaning);
    final available =
        source
            .where(
              (word) =>
                  word.hanzi != draft.hanzi &&
                  word.pinyin.toLowerCase() != draft.pinyin.toLowerCase() &&
                  _firstMeaning(word.meaning) != _firstMeaning(draft.meaning),
            )
            .toList()
          ..sort((a, b) {
            if (related.isNotEmpty) {
              final byCategory = (category(b.meaning) == related ? 1 : 0)
                  .compareTo(category(a.meaning) == related ? 1 : 0);
              if (byCategory != 0) return byCategory;
            }
            return a.meaning.compareTo(b.meaning);
          });
    final chosen = <CustomChoiceWord>[];
    final seenHanzi = <String>{},
        seenPinyin = <String>{},
        seenMeaning = <String>{};
    for (final word in available) {
      if (seenHanzi.contains(word.hanzi) ||
          seenPinyin.contains(word.pinyin.toLowerCase()) ||
          seenMeaning.contains(_firstMeaning(word.meaning)))
        continue;
      chosen.add(word);
      seenHanzi.add(word.hanzi);
      seenPinyin.add(word.pinyin.toLowerCase());
      seenMeaning.add(_firstMeaning(word.meaning));
      if (chosen.length == 3) break;
    }
    if (chosen.length != 3) {
      throw const FormatException(
        'Not enough distinct words to build questions.',
      );
    }
    Map<String, Object?> question(
      String kind,
      String prompt,
      String field, {
      bool typed = false,
    }) {
      String value(CustomChoiceWord word) => switch (field) {
        'hanzi' => word.hanzi,
        'pinyin' => word.pinyin,
        _ => word.meaning,
      };
      final target = CustomChoiceWord(
        draft.hanzi.trim(),
        draft.pinyin.trim(),
        draft.meaning.trim(),
      );
      return {
        'id': '$id.$kind',
        'kind': kind,
        'prompt': prompt,
        'options': [
          {'id': 'correct', 'text': value(target)},
          if (!typed)
            for (var i = 0; i < chosen.length; i++)
              {'id': 'choice-$i', 'text': value(chosen[i])},
        ],
        'correctOptionId': 'correct',
        'explanation':
            '${draft.hanzi.trim()} · ${draft.pinyin.trim()} · ${draft.meaning.trim()}.',
      };
    }

    final result = [
      question('meaning', 'What does ${draft.hanzi} mean?', 'meaning'),
      question('hanzi', 'Which Hanzi means “${draft.meaning}”?', 'hanzi'),
      question('pinyin', 'Choose the Pinyin for ${draft.hanzi}.', 'pinyin'),
      question('pinyin_hanzi', 'Which Hanzi matches ${draft.pinyin}?', 'hanzi'),
      question(
        'meaning_pinyin',
        'Which Pinyin means “${draft.meaning}”?',
        'pinyin',
      ),
      question('pinyin_meaning', 'What does ${draft.pinyin} mean?', 'meaning'),
      question(
        'typed_hanzi',
        'Type the Chinese word for “${draft.meaning}”.',
        'hanzi',
        typed: true,
      ),
    ];
    final cloze = draft.examples
        .where((e) => e.hanzi.split(draft.hanzi).length == 2)
        .firstOrNull;
    if (cloze != null) {
      result.insert(
        result.length - 1,
        question(
          'cloze',
          'Complete the sentence: ${cloze.hanzi.replaceFirst(draft.hanzi, '____')} English: ${cloze.meaning}',
          'hanzi',
        ),
      );
    }
    return result;
  }
}
