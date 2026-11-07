import 'dart:convert';

import 'learning_priority.dart';

/// Structural validation only. Review declarations must still be checked by
/// the curator; this parser cannot establish language accuracy or reuse rights.
class VocabularyPack {
  VocabularyPack._(
    this.id,
    this.revision,
    this.schemaVersion,
    List<VocabularyEntry> entries,
  ) : entries = List.unmodifiable(entries);

  final String id;
  final int revision;
  final int schemaVersion;
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
    final schema = pack['schemaVersion'];
    if (schema is! int || !{1, 2, 3, 4}.contains(schema)) {
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
        if (schema >= 2) 'questions',
        if (schema >= 3) 'details',
      });
      final id = _id(word['id']);
      if (!ids.add(id)) throw const FormatException('Duplicate word ID.');
      if (word['reviewStatus'] != 'approved' &&
          !(schema >= 2 && word['reviewStatus'] == 'source-checked-pilot') &&
          !(schema == 4 && word['reviewStatus'] == 'source-imported')) {
        throw const FormatException('Word review is incomplete.');
      }
      // This field is reserved for recorded word audio; device TTS uses Hanzi by ID.
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
      if (examples is! List ||
          (schema == 4 ? examples.length > 5 : examples.length != 5)) {
        throw const FormatException(
          'Each word requires exactly five examples.',
        );
      }
      final sentences = <String>{};
      final checkedExamples = <VocabularyExample>[];
      for (final value in examples) {
        final example = _record(value, {
          'hanzi',
          'pinyin',
          'meaning',
          if (schema >= 3) ...{
            'traditional',
            'sourceId',
            'sourceUrl',
            'grammarTags',
            if (value is Map && value.containsKey('audio')) 'audio',
            if (schema == 4 && value is Map) ...[
              for (final key in [
                'credit',
                'translationSourceUrl',
                'annotation',
              ])
                if (value.containsKey(key)) key,
            ],
          },
        });
        final hanzi = _text(example, 'hanzi', 500);
        if (!sentences.add(hanzi)) {
          throw const FormatException('Repeated example sentence.');
        }
        checkedExamples.add(
          VocabularyExample._(
            hanzi,
            _text(example, 'pinyin', 1000),
            _text(example, 'meaning', 1000),
            traditional: schema >= 3
                ? _text(example, 'traditional', 500)
                : null,
            sourceId: schema >= 3 ? _id(example['sourceId']) : null,
            sourceUrl: schema >= 3 ? _https(example, 'sourceUrl') : null,
            grammarTags: schema >= 3 ? _tags(example['grammarTags']) : const [],
            audio: example['audio'] == null
                ? null
                : SentenceAudio.parse(example['audio']),
            credit: example['credit'] == null
                ? null
                : _text(example, 'credit', 1000),
            translationSourceUrl: example['translationSourceUrl'] == null
                ? null
                : _https(example, 'translationSourceUrl'),
            annotation: example['annotation'] == null
                ? null
                : _text(example, 'annotation', 1000),
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
          word['reviewStatus'] as String,
          schema >= 2 ? _questions(word['questions'], schema) : const [],
          schema >= 3 ? WordDetails.parse(word['details']) : null,
        ),
      );
    }
    return VocabularyPack._(_id(pack['id']), revision, schema, entries);
  }

  Map<String, Object?> toJson() => {
    'schemaVersion': schemaVersion,
    'id': id,
    'revision': revision,
    'words': entries.map((e) => e.toJson(schemaVersion)).toList(),
  };
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
    this.reviewStatus,
    List<VocabularyQuestion> questions,
    this.details,
  ) : examples = List.unmodifiable(examples),
      questions = List.unmodifiable(questions);
  final String id, hanzi, pinyin, meaning;
  final List<VocabularyExample> examples;
  final List<VocabularyQuestion> questions;
  // These declarations cover the word and all five examples as one review unit.
  final String source, license, reviewedBy, reviewedOn;
  final String reviewStatus;
  final WordDetails? details;

  Map<String, Object?> toJson(int schema) => {
    'id': id,
    'hanzi': hanzi,
    'pinyin': pinyin,
    'meaning': meaning,
    'examples': examples.map((e) => e.toJson(schema)).toList(),
    'source': source,
    'license': license,
    'reviewedBy': reviewedBy,
    'reviewedOn': reviewedOn,
    'reviewStatus': reviewStatus,
    'audio': null,
    if (schema >= 2) 'questions': questions.map((q) => q.toJson()).toList(),
    if (schema >= 3) 'details': details!.toJson(),
  };
}

class WordDetails {
  const WordDetails(
    this.traditional,
    this.pinyinNumbered,
    this.partOfSpeech,
    this.band,
    this.sourceId,
    this.sourceVersion,
    this.sourceUrl,
    this.licenseUrl, [
    this.learningPriority,
  ]);
  final String traditional,
      pinyinNumbered,
      partOfSpeech,
      sourceId,
      sourceVersion,
      sourceUrl,
      licenseUrl;
  final int band;
  final LearningPriority? learningPriority;
  factory WordDetails.parse(Object? raw) {
    final value = _record(raw, {
      'traditional',
      'pinyinNumbered',
      'partOfSpeech',
      'band',
      'sourceId',
      'sourceVersion',
      'sourceUrl',
      'licenseUrl',
      if (raw is Map && raw.containsKey('learningPriority')) 'learningPriority',
    });
    final band = value['band'];
    if (band is! int || band < 0 || band > 7)
      throw const FormatException('Invalid word band.');
    return WordDetails(
      _text(value, 'traditional', 100),
      _text(value, 'pinyinNumbered', 300),
      _text(value, 'partOfSpeech', 200),
      band,
      _id(value['sourceId']),
      _text(value, 'sourceVersion', 100),
      _https(value, 'sourceUrl'),
      _https(value, 'licenseUrl'),
      value['learningPriority'] == null
          ? null
          : LearningPriority.parse(value['learningPriority']),
    );
  }
  Map<String, Object?> toJson() => {
    'traditional': traditional,
    'pinyinNumbered': pinyinNumbered,
    'partOfSpeech': partOfSpeech,
    'band': band,
    'sourceId': sourceId,
    'sourceVersion': sourceVersion,
    'sourceUrl': sourceUrl,
    'licenseUrl': licenseUrl,
    if (learningPriority != null)
      'learningPriority': learningPriority!.toJson(),
  };
}

class VocabularyExample {
  VocabularyExample._(
    this.hanzi,
    this.pinyin,
    this.meaning, {
    this.traditional,
    this.sourceId,
    this.sourceUrl,
    this.audio,
    this.credit,
    this.translationSourceUrl,
    this.annotation,
    List<String> grammarTags = const [],
  }) : grammarTags = List.unmodifiable(grammarTags);
  final String hanzi, pinyin, meaning;
  final String? traditional, sourceId, sourceUrl;
  final List<String> grammarTags;
  final SentenceAudio? audio;
  final String? credit, translationSourceUrl, annotation;
  Map<String, Object?> toJson(int schema) => {
    'hanzi': hanzi,
    'pinyin': pinyin,
    'meaning': meaning,
    if (schema >= 3) ...{
      'traditional': traditional,
      'sourceId': sourceId,
      'sourceUrl': sourceUrl,
      'grammarTags': grammarTags,
      if (audio != null) 'audio': audio!.toJson(),
      if (credit != null) 'credit': credit,
      if (translationSourceUrl != null)
        'translationSourceUrl': translationSourceUrl,
      if (annotation != null) 'annotation': annotation,
    },
  };
}

class SentenceAudio {
  const SentenceAudio(
    this.asset,
    this.url,
    this.sha256,
    this.bytes,
    this.speed,
    this.license,
    this.voice,
  );
  final String asset, url, sha256, speed, license, voice;
  final int bytes;
  factory SentenceAudio.parse(Object? raw) {
    final value = _record(raw, {
      'asset',
      'url',
      'sha256',
      'bytes',
      'speed',
      'license',
      'voice',
      'synthetic',
    });
    final asset = _text(value, 'asset', 200);
    final hash = _text(value, 'sha256', 64);
    final bytes = value['bytes'];
    if (!RegExp(r'^assets/audio/hsk[1-6]-[0-9]{4}(?:_slow)?\.mp3$')
            .hasMatch(asset) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(hash) ||
        bytes is! int ||
        bytes < 1 ||
        bytes > 2000000 ||
        value['synthetic'] != true ||
        !{'normal', 'slow'}.contains(value['speed']) ||
        value['license'] != 'CC BY-SA 4.0') {
      throw const FormatException('Invalid bundled sentence audio metadata.');
    }
    return SentenceAudio(
      asset,
      _https(value, 'url'),
      hash,
      bytes,
      value['speed'] as String,
      value['license'] as String,
      _text(value, 'voice', 200),
    );
  }
  Map<String, Object?> toJson() => {
    'asset': asset,
    'url': url,
    'sha256': sha256,
    'bytes': bytes,
    'speed': speed,
    'license': license,
    'voice': voice,
    'synthetic': true,
  };
}

class VocabularyQuestion {
  VocabularyQuestion._(
    this.id,
    this.kind,
    this.prompt,
    Map<String, String> options,
    this.correctOptionId,
    this.explanation,
  ) : options = Map.unmodifiable(options);
  final String id, kind, prompt, correctOptionId, explanation;
  final Map<String, String> options;
  bool get isTyped => kind == 'typed_hanzi';
  String get correctAnswer => options[correctOptionId]!;
  bool accepts(String? answer) =>
      answer != null &&
      (isTyped
          ? answer.trim().isNotEmpty &&
                answer.length <= 100 &&
                !RegExp(r'[\x00-\x1f\x7f-\x9f]').hasMatch(answer)
          : options.containsKey(answer));
  bool isCorrect(String? answer) =>
      accepts(answer) &&
      (isTyped ? answer!.trim() == correctAnswer : answer == correctOptionId);
  String displayAnswer(String answer) =>
      isTyped ? answer : options[answer] ?? answer;
  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind,
    'prompt': prompt,
    'options': options.entries
        .map((o) => {'id': o.key, 'text': o.value})
        .toList(),
    'correctOptionId': correctOptionId,
    'explanation': explanation,
  };
}

List<VocabularyQuestion> _questions(Object? value, int schema) {
  if (value is! List ||
      (schema == 2
          ? value.length != 2
          : value.length < 4 || value.length > 24)) {
    throw const FormatException('Invalid question bank size for this schema.');
  }
  final ids = <String>{};
  final kinds = <String>{};
  final questions = value
      .map((raw) {
        final q = _record(raw, {
          'id',
          'kind',
          'prompt',
          'options',
          'correctOptionId',
          'explanation',
        });
        final id = _id(q['id']);
        final kind = _text(q, 'kind', 40);
        final allowed = schema == 2
            ? {'meaning', 'hanzi'}
            : {
                'meaning',
                'hanzi',
                'pinyin',
                'pinyin_hanzi',
                'meaning_pinyin',
                'pinyin_meaning',
                'cloze',
                'typed_hanzi',
              };
        if (!ids.add(id) ||
            !allowed.contains(kind) ||
            (schema == 2 && kinds.contains(kind))) {
          throw const FormatException('Invalid question identity or kind.');
        }
        kinds.add(kind);
        final options = q['options'];
        if (options is! List ||
            options.length != (kind == 'typed_hanzi' ? 1 : 4)) {
          throw const FormatException('Invalid option/accepted-answer count.');
        }
        final choices = <String, String>{};
        final labels = <String>{};
        for (final raw in options) {
          final option = _record(raw, {'id', 'text'});
          final optionId = _id(option['id']);
          final label = _text(option, 'text', 500);
          if (choices.containsKey(optionId) || !labels.add(label)) {
            throw const FormatException('Repeated quiz option.');
          }
          choices[optionId] = label;
        }
        final correct = _id(q['correctOptionId']);
        if (!choices.containsKey(correct))
          throw const FormatException('Missing correct option.');
        return VocabularyQuestion._(
          id,
          kind,
          _text(q, 'prompt', 1000),
          choices,
          correct,
          _text(q, 'explanation', 1500),
        );
      })
      .toList(growable: false);
  if (schema >= 3 &&
      !kinds.containsAll({'meaning', 'hanzi', 'pinyin', 'pinyin_hanzi'})) {
    throw const FormatException(
      'A lesson requires meaning, Hanzi and both Pinyin directions.',
    );
  }
  return questions;
}

String _https(Map<String, dynamic> value, String field) {
  final result = _text(value, field, 2000);
  final uri = Uri.tryParse(result);
  if (uri == null ||
      uri.scheme != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty) {
    throw const FormatException('Expected an HTTPS source URL.');
  }
  return result;
}

List<String> _tags(Object? value) {
  if (value is! List || value.length > 30)
    throw const FormatException('Invalid grammar tags.');
  final tags = value.map((v) => _text({'tag': v}, 'tag', 100)).toList();
  if (tags.toSet().length != tags.length)
    throw const FormatException('Repeated grammar tag.');
  return tags;
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
