import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import 'content_pack.dart';
import 'custom_word.dart';
import 'pinyin_input.dart';
import 'vocabulary_repository.dart';
import 'word_teaching.dart';

String _curriculumDigest(Uint8List bytes) => sha256.convert(bytes).toString();

class QueueWord {
  const QueueWord(this.id, this.hanzi, this.pinyin, this.meaning);
  final String id, hanzi, pinyin, meaning;
}

class QueuePage {
  const QueuePage(this.words, this.hasMore);
  final List<QueueWord> words;
  final bool hasMore;
}

class CustomWordClash {
  const CustomWordClash(this.word, this.fields, this.alreadyStarted);
  final QueueWord word;
  final List<String> fields;
  final bool alreadyStarted;
}

class CustomWordConflict implements Exception {
  const CustomWordConflict(this.clash);
  final CustomWordClash clash;
}

enum WordCategory {
  customWords('Custom words', []),
  measureWords('Measure words', ['measure word']),
  numbers('Numbers', ['numeral', 'quantity']),
  nouns('Nouns', ['noun']),
  verbs('Verbs', ['verb']),
  adjectives('Adjectives', ['adjective']),
  pronouns('Pronouns', ['pronoun']),
  adverbs('Adverbs', ['adverb']),
  particles('Particles', ['particle']),
  prepositions('Prepositions', ['preposition']),
  conjunctions('Conjunctions', ['conjunction']);

  const WordCategory(this.label, this.partsOfSpeech);
  final String label;
  final List<String> partsOfSpeech;
}

class CurriculumRepository {
  CurriculumRepository(
    this.database, {
    AssetBundle? bundle,
    this.seedFile,
    this.manifest,
  }) : bundle = bundle ?? rootBundle;
  final AppDatabase database;
  final AssetBundle bundle;
  final File? seedFile;
  final Map<String, dynamic>? manifest;
  Future<void>? _ready;

  Future<void> ready() =>
      _ready ??= _install().catchError((Object error, StackTrace stack) {
        _ready = null;
        Error.throwWithStackTrace(error, stack);
      });

  Future<void> _install() async {
    final metadata =
        manifest ??
        jsonDecode(
          await bundle.loadString('assets/content/curriculum.manifest.json'),
        ) as Map<String, dynamic>;
    final digest = metadata['sha256'], revision = metadata['revision'];
    if (digest is! String ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(digest) ||
        revision is! int ||
        revision < 1) {
      throw const FormatException('Invalid curriculum manifest.');
    }
    final installed = await database
        .select(database.curriculumInstalls)
        .getSingleOrNull();
    if (installed != null) {
      if (installed.revision > revision) return;
      if (installed.revision == revision) {
        if (installed.digest != digest)
          throw const FormatException('Curriculum changed without revision.');
        return;
      }
    }
    final bytes = seedFile != null
        ? await seedFile!.readAsBytes()
        : (await bundle.load('assets/content/curriculum.sqlite')).buffer
              .asUint8List();
    if (bytes.length > 150000000 ||
        await compute(_curriculumDigest, bytes) != digest) {
      throw const FormatException('Curriculum checksum mismatch.');
    }
    final directory = await Directory.systemTemp.createTemp(
      'nihao-curriculum-',
    );
    final file = File('${directory.path}/verified.sqlite');
    await file.writeAsBytes(bytes, flush: true);
    var attached = false;
    try {
      await database.transaction(() async {
        await database.customStatement('ATTACH DATABASE ? AS curriculum_seed', [
          file.path,
        ]);
        attached = true;
        final integrity = await database
            .customSelect('PRAGMA curriculum_seed.integrity_check')
            .get();
        if (integrity.length != 1 ||
            integrity.single.data.values.single != 'ok' ||
            (await database
                    .customSelect('PRAGMA curriculum_seed.foreign_key_check')
                    .get())
                .isNotEmpty) {
          throw const FormatException('Invalid curriculum database.');
        }
        // Insert parents first. Never delete words referenced by queues or history.
        await database.customStatement(
          '''INSERT INTO curriculum_words SELECT * FROM curriculum_seed.curriculum_words WHERE true
          ON CONFLICT(id) DO UPDATE SET pack_id=excluded.pack_id, revision=excluded.revision,
          content_schema=excluded.content_schema, hanzi=excluded.hanzi,pinyin=excluded.pinyin,meaning=excluded.meaning,
          search_text=excluded.search_text,default_position=excluded.default_position,metadata_json=excluded.metadata_json''',
        );
        await database.customStatement('''INSERT INTO curriculum_sentences SELECT * FROM curriculum_seed.curriculum_sentences WHERE true
          ON CONFLICT(id) DO UPDATE SET payload_json=excluded.payload_json''');
        // A seed revision replaces bundled child rows without deleting local
        // learner-authored lessons or their examples and question links.
        await database.customStatement(
          '''DELETE FROM curriculum_examples
          WHERE word_id IN (SELECT id FROM curriculum_seed.curriculum_words)''',
        );
        await database.customStatement(
          '''DELETE FROM curriculum_questions
          WHERE word_id IN (SELECT id FROM curriculum_seed.curriculum_words)''',
        );
        await database.customStatement(
          '''DELETE FROM curriculum_audio
          WHERE sentence_id IN (SELECT id FROM curriculum_seed.curriculum_sentences)''',
        );
        for (final table in [
          'curriculum_examples',
          'curriculum_audio',
          'curriculum_questions',
        ]) {
          await database.customStatement(
            'INSERT INTO $table SELECT * FROM curriculum_seed.$table',
          );
        }
        if ((await database.customSelect('PRAGMA foreign_key_check').get())
            .isNotEmpty) {
          throw const FormatException('Curriculum links are inconsistent.');
        }
        await database
            .into(database.curriculumInstalls)
            .insertOnConflictUpdate(
              CurriculumInstallsCompanion.insert(
                id: const Value(1),
                revision: revision,
                digest: digest,
              ),
            );
      });
    } finally {
      if (attached)
        await database.customStatement('DETACH DATABASE curriculum_seed');
      await file.delete();
      await directory.delete();
    }
  }

  Future<CatalogueWord?> lesson(String id, {int? profile}) async {
    await ready();
    final row = await (database.select(
      database.curriculumWords,
    )..where((w) => w.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final examples = await database
        .customSelect(
          '''
      SELECT s.payload_json, a.payload_json AS audio_json
      FROM curriculum_examples e JOIN curriculum_sentences s ON s.id=e.sentence_id
      LEFT JOIN curriculum_audio a ON a.sentence_id=s.id AND a.local_available=1
      WHERE e.word_id=? ORDER BY e.position
    ''',
          variables: [Variable(id)],
        )
        .get();
    final questions =
        await (database.select(database.curriculumQuestions)
              ..where((q) => q.wordId.equals(id))
              ..orderBy([(q) => OrderingTerm.asc(q.position)]))
            .get();
    final word = jsonDecode(row.metadataJson) as Map<String, dynamic>;
    word.remove('ownerProfileId');
    final personalExamples = profile == null
        ? null
        : await database
              .customSelect(
                'SELECT examples_json, explanation FROM profile_word_examples WHERE profile_id=? AND word_id=?',
                variables: [Variable(profile), Variable(id)],
              )
              .getSingleOrNull();
    final teaching = (word.remove('teaching') as List? ?? [])
        .map((sense) => TeachingSense(sense as Map<String, dynamic>))
        .toList();
    word['examples'] = examples
        .map(
          (r) => <String, dynamic>{
            ...jsonDecode(r.read<String>('payload_json'))
                as Map<String, dynamic>,
            if (r.readNullable<String>('audio_json') case final audio?)
              'audio': jsonDecode(audio),
          },
        )
        .toList();
    word['questions'] = questions
        .map((q) => jsonDecode(q.payloadJson))
        .toList();
    final pack = VocabularyPack.parse(
      jsonEncode({
        'schemaVersion': row.contentSchema,
        'id': row.packId,
        'revision': row.revision,
        'words': [word],
      }),
    );
    var entry = pack.entries.single;
    if (personalExamples != null) {
      final raw = jsonDecode(personalExamples.read<String>('examples_json'));
      if (raw is! List || raw.length != 5) {
        throw const FormatException('Invalid saved personal examples.');
      }
      final personal = [
        for (final item in raw)
          VocabularyExample.personal(item as Map<String, dynamic>),
      ];
      if (personal.any((example) => !example.hanzi.contains(entry.hanzi)) ||
          personal.map((example) => example.hanzi).toSet().length != 5) {
        throw const FormatException('Invalid saved personal examples.');
      }
      entry = entry.withPersonalExamples(
        personal,
        explanation: personalExamples.read<String>('explanation'),
      );
    }
    return CatalogueWord(pack.id, pack.revision, entry, teaching: teaching);
  }

  Future<void> _queue(int profile) async {
    await ready();
    await database.transaction(() async {
      if (await (database.select(
            database.profiles,
          )..where((p) => p.id.equals(profile))).getSingleOrNull() ==
          null) {
        throw StateError('Profile no longer exists.');
      }
      await database.customStatement(
        '''
        INSERT INTO learning_queue(profile_id,word_id,position)
        SELECT ?, w.id, COALESCE((SELECT max(position)+1 FROM learning_queue WHERE profile_id=?),0)
          + ROW_NUMBER() OVER(ORDER BY w.default_position,w.id)-1
        FROM curriculum_words w WHERE (w.pack_id NOT LIKE 'custom.%'
          OR json_extract(w.metadata_json,'\$.ownerProfileId')=?) AND NOT EXISTS
          (SELECT 1 FROM learning_queue q WHERE q.profile_id=? AND q.word_id=w.id)
      ''',
        [profile, profile, profile, profile],
      );
    });
  }

  Future<CustomWordClash?> findCustomClash(
    int profile,
    String hanzi,
    String pinyin,
    String meaning,
  ) async {
    CustomWordDraft.validateWord(hanzi, pinyin, meaning);
    await _queue(profile);
    return _customClash(profile, hanzi, pinyin, meaning);
  }

  Future<CustomWordClash?> _customClash(
    int profile,
    String hanzi,
    String pinyin,
    String meaning, {
    String? excludeId,
  }) async {
    final rows = await database
        .customSelect(
          '''
      SELECT w.id,w.hanzi,w.pinyin,w.meaning,
        CASE WHEN p.word_id IS NULL THEN 0 ELSE 1 END AS started
      FROM curriculum_words w
      LEFT JOIN vocabulary_progress p ON p.word_id=w.id AND p.profile_id=?
      WHERE w.pack_id NOT LIKE 'custom.%'
        OR json_extract(w.metadata_json,'\$.ownerProfileId')=?
      ORDER BY w.default_position,w.id
    ''',
          variables: [Variable(profile), Variable(profile)],
        )
        .get();
    final wantedPinyin = PinyinInputEngine.normalize(pinyin);
    final wantedMeaning = meaning.trim().toLowerCase();
    CustomWordClash? best;
    var bestScore = 0;
    for (final row in rows) {
      if (row.read<String>('id') == excludeId) continue;
      final fields = <String>[];
      if (row.read<String>('hanzi') == hanzi.trim()) fields.add('Hanzi');
      if (wantedPinyin.isNotEmpty &&
          PinyinInputEngine.normalize(row.read<String>('pinyin')) ==
              wantedPinyin) {
        fields.add('Pinyin');
      }
      if (row.read<String>('meaning').trim().toLowerCase() == wantedMeaning) {
        fields.add('English meaning');
      }
      final score =
          (fields.contains('Hanzi') ? 4 : 0) +
          (fields.contains('Pinyin') ? 2 : 0) +
          (fields.contains('English meaning') ? 1 : 0);
      if (score > bestScore) {
        bestScore = score;
        best = CustomWordClash(
          QueueWord(
            row.read<String>('id'),
            row.read<String>('hanzi'),
            row.read<String>('pinyin'),
            row.read<String>('meaning'),
          ),
          List.unmodifiable(fields),
          row.read<int>('started') == 1,
        );
        if (score == 7) break;
      }
    }
    return best;
  }

  Future<void> bringToFront(int profile, String id) =>
      move(profile, id, 'front');

  /// Keeps a bundled word and its progress, but gives this profile its own
  /// five examples. Importing the same word again replaces the personal set.
  Future<void> attachExamplesToExistingWord(
    int profile,
    String id,
    CustomWordDraft draft,
  ) async {
    draft.validate();
    await _queue(profile);
    await database.transaction(() async {
      final row = await database
          .customSelect(
            'SELECT hanzi,pinyin,pack_id FROM curriculum_words WHERE id=?',
            variables: [Variable(id)],
          )
          .getSingleOrNull();
      if (row == null ||
          row.read<String>('pack_id').startsWith('custom.') ||
          row.read<String>('hanzi') != draft.hanzi.trim() ||
          PinyinInputEngine.normalize(row.read<String>('pinyin')) !=
              PinyinInputEngine.normalize(draft.pinyin)) {
        throw const FormatException(
          'The existing word must match both Hanzi and Pinyin to add its examples.',
        );
      }
      final personalExamples = [
        for (var i = 0; i < 5; i++)
          {
            'hanzi': draft.examples[i].hanzi.trim(),
            'pinyin': draft.examples[i].pinyin.trim(),
            'meaning': draft.examples[i].meaning.trim(),
            'traditional': null,
            'sourceId': '$id.user.example.$i',
            'sourceUrl': null,
            'grammarTags': <String>[],
            'credit': 'Imported from learner-provided text',
          },
      ];
      await database.customStatement(
        '''INSERT INTO profile_word_examples(profile_id,word_id,examples_json,explanation,updated_at_ms)
           VALUES(?,?,?,?,?)
           ON CONFLICT(profile_id,word_id) DO UPDATE SET
             examples_json=excluded.examples_json,
             explanation=excluded.explanation,
             updated_at_ms=excluded.updated_at_ms''',
        [
          profile,
          id,
          jsonEncode(personalExamples),
          draft.explanation.trim(),
          DateTime.now().millisecondsSinceEpoch,
        ],
      );
    });
  }

  Future<QueueWord> addCustomWord(int profile, CustomWordDraft draft) async {
    draft.validate();
    await _queue(profile);
    return database.transaction(() => _insertCustomWord(profile, draft));
  }

  /// Imports a small CSV batch as one transaction, preserving CSV order at
  /// the front of the queue. A conflict rolls back every word in the batch.
  Future<List<QueueWord>> importCustomWords(
    int profile,
    List<CustomWordDraft> drafts,
  ) async {
    if (drafts.isEmpty || drafts.length > 20) {
      throw const FormatException('Import between 1 and 20 words at a time.');
    }
    for (final draft in drafts) {
      draft.validate();
    }
    await _queue(profile);
    return database.transaction(() async {
      final imported = <QueueWord>[];
      for (final draft in drafts.reversed) {
        imported.add(await _insertCustomWord(profile, draft));
      }
      return List<QueueWord>.unmodifiable(imported.reversed);
    });
  }

  Future<Map<String, dynamic>?> _ownedCustomMetadata(
    int profile,
    String id,
  ) async {
    final row = await database
        .customSelect(
          'SELECT metadata_json FROM curriculum_words WHERE id=? AND pack_id=?',
          variables: [Variable(id), Variable('custom.p$profile')],
        )
        .getSingleOrNull();
    if (row == null) return null;
    final metadata =
        jsonDecode(row.read<String>('metadata_json')) as Map<String, dynamic>;
    return metadata['ownerProfileId'] == profile ? metadata : null;
  }

  /// Returns only words created by this profile, including already learned
  /// and mastered words.
  Future<CustomWordDraft?> editableCustomWord(int profile, String id) async {
    await ready();
    final metadata = await _ownedCustomMetadata(profile, id);
    if (metadata == null) return null;
    final examples = metadata['examples'] as List;
    return CustomWordDraft(
      hanzi: metadata['hanzi'] as String,
      pinyin: metadata['pinyin'] as String,
      meaning: metadata['meaning'] as String,
      examples: [
        for (final raw in examples)
          CustomSentence(
            (raw as Map<String, dynamic>)['hanzi'] as String,
            raw['pinyin'] as String,
            raw['meaning'] as String,
          ),
      ],
      explanation: metadata['customExplanation'] as String? ?? '',
      imported: (metadata['source'] as String).startsWith('Imported'),
    );
  }

  /// Edits the existing lesson in place. The word, sentence, and question IDs
  /// stay stable so queue placement, progress, and past attempts remain linked.
  Future<void> updateCustomWord(
    int profile,
    String id,
    CustomWordDraft draft,
  ) async {
    draft.validate();
    await ready();
    await database.transaction(() async {
      final metadata = await _ownedCustomMetadata(profile, id);
      if (metadata == null) {
        throw StateError('Only your custom words can be edited.');
      }
      final clash = await _customClash(
        profile,
        draft.hanzi,
        draft.pinyin,
        draft.meaning,
        excludeId: id,
      );
      if (clash != null) throw CustomWordConflict(clash);
      final pool = await database
          .customSelect(
            '''
        SELECT hanzi,pinyin,meaning FROM curriculum_words
        WHERE pack_id NOT LIKE 'custom.%'
          OR json_extract(metadata_json,'\$.ownerProfileId')=?
        ORDER BY default_position,id
      ''',
            variables: [Variable(profile)],
          )
          .get();
      final questions = CustomWordQuestions.build(
        id,
        draft,
        pool
            .where((row) => row.read<String>('hanzi') != metadata['hanzi'])
            .map(
              (row) => CustomChoiceWord(
                row.read<String>('hanzi'),
                row.read<String>('pinyin'),
                row.read<String>('meaning'),
              ),
            ),
      );
      metadata['hanzi'] = draft.hanzi.trim();
      metadata['pinyin'] = draft.pinyin.trim();
      metadata['meaning'] = draft.meaning.trim();
      metadata['examples'] = [
        for (var i = 0; i < 5; i++)
          {
            'hanzi': draft.examples[i].hanzi.trim(),
            'pinyin': draft.examples[i].pinyin.trim(),
            'meaning': draft.examples[i].meaning.trim(),
            'traditional': null,
            'sourceId': '$id.example.$i',
            'sourceUrl': null,
            'grammarTags': <String>[],
            'credit': 'Edited by this learner',
          },
      ];
      metadata['questions'] = questions;
      metadata['customExplanation'] = draft.explanation.trim().isEmpty
          ? null
          : draft.explanation.trim();
      metadata['source'] = 'Learner-edited content on this device.';
      metadata['license'] =
          'Learner-supplied text; source rights not independently verified.';
      metadata['reviewedBy'] =
          'Edited by learner; independent language review not performed';
      metadata['reviewedOn'] = DateTime.now()
          .toUtc()
          .toIso8601String()
          .substring(0, 10);
      final revisionRow = await database
          .customSelect(
            'SELECT revision FROM curriculum_words WHERE id=?',
            variables: [Variable(id)],
          )
          .getSingle();
      final revision = revisionRow.read<int>('revision') + 1;
      final preview = {...metadata}..remove('ownerProfileId');
      VocabularyPack.parse(
        jsonEncode({
          'schemaVersion': 5,
          'id': 'custom.p$profile',
          'revision': revision,
          'words': [preview],
        }),
      );
      final search =
          '${draft.hanzi} ${draft.pinyin} ${draft.meaning} '
                  '${PinyinInputEngine.normalize(draft.pinyin)}'
              .toLowerCase();
      await database.customStatement(
        '''
        UPDATE curriculum_words
        SET revision=?, hanzi=?, pinyin=?, meaning=?, search_text=?, metadata_json=?
        WHERE id=?
      ''',
        [
          revision,
          draft.hanzi.trim(),
          draft.pinyin.trim(),
          draft.meaning.trim(),
          search,
          jsonEncode(metadata),
          id,
        ],
      );
      for (var i = 0; i < 5; i++) {
        await database.customStatement(
          'UPDATE curriculum_sentences SET payload_json=? WHERE id=?',
          [jsonEncode((metadata['examples'] as List)[i]), '$id.sentence.$i'],
        );
      }
      await database.customStatement(
        'DELETE FROM curriculum_questions WHERE word_id=?',
        [id],
      );
      for (var i = 0; i < questions.length; i++) {
        await database.customStatement(
          'INSERT INTO curriculum_questions(id,word_id,position,payload_json) VALUES(?,?,?,?)',
          [questions[i]['id'], id, i, jsonEncode(questions[i])],
        );
      }
    });
  }

  /// Permanently removes a word created by this profile and its study data.
  /// Bundled words and another profile's custom words cannot be deleted here.
  Future<void> deleteCustomWord(int profile, String id) async {
    await ready();
    await database.transaction(() async {
      if (await _ownedCustomMetadata(profile, id) == null) {
        throw StateError('Only your custom words can be deleted.');
      }
      final sentenceRows = await database
          .customSelect(
            'SELECT sentence_id FROM curriculum_examples WHERE word_id=?',
            variables: [Variable(id)],
          )
          .get();
      final sentenceIds = [
        for (final row in sentenceRows) row.read<String>('sentence_id'),
      ];
      for (final table in [
        'vocabulary_attempts',
        'vocabulary_progress',
        'practice_responses',
        'mastered_words',
        'master_writings',
        'learning_queue',
        'profile_word_examples',
      ]) {
        await database.customStatement(
          'DELETE FROM $table WHERE profile_id=? AND word_id=?',
          [profile, id],
        );
      }
      await database.customStatement(
        'DELETE FROM curriculum_questions WHERE word_id=?',
        [id],
      );
      await database.customStatement(
        'DELETE FROM curriculum_examples WHERE word_id=?',
        [id],
      );
      for (final sentenceId in sentenceIds) {
        await database.customStatement(
          'DELETE FROM curriculum_audio WHERE sentence_id=?',
          [sentenceId],
        );
        await database.customStatement(
          'DELETE FROM curriculum_sentences WHERE id=?',
          [sentenceId],
        );
      }
      await database.customStatement(
        'DELETE FROM curriculum_words WHERE id=?',
        [id],
      );
    });
  }

  Future<QueueWord> _insertCustomWord(
    int profile,
    CustomWordDraft draft,
  ) async {
    final clash = await _customClash(
      profile,
      draft.hanzi,
      draft.pinyin,
      draft.meaning,
    );
    if (clash != null) throw CustomWordConflict(clash);
    final random = Random.secure();
    final suffix = List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final id = 'custom.p$profile.$suffix';
    final pool = await database
        .customSelect(
          '''
        SELECT hanzi,pinyin,meaning FROM curriculum_words
        WHERE pack_id NOT LIKE 'custom.%'
          OR json_extract(metadata_json,'\$.ownerProfileId')=?
        ORDER BY default_position,id
      ''',
          variables: [Variable(profile)],
        )
        .get();
    final questions = CustomWordQuestions.build(
      id,
      draft,
      pool.map(
        (row) => CustomChoiceWord(
          row.read<String>('hanzi'),
          row.read<String>('pinyin'),
          row.read<String>('meaning'),
        ),
      ),
    );
    final today = DateTime.now().toUtc().toIso8601String().substring(0, 10);
    final word = <String, Object?>{
      'id': id,
      'hanzi': draft.hanzi.trim(),
      'pinyin': draft.pinyin.trim(),
      'meaning': draft.meaning.trim(),
      'examples': [
        for (var i = 0; i < 5; i++)
          {
            'hanzi': draft.examples[i].hanzi.trim(),
            'pinyin': draft.examples[i].pinyin.trim(),
            'meaning': draft.examples[i].meaning.trim(),
            'traditional': null,
            'sourceId': '$id.example.$i',
            'sourceUrl': null,
            'grammarTags': <String>[],
            'credit': draft.imported
                ? 'Imported from learner-provided text'
                : 'Written by this learner',
          },
      ],
      'source': draft.imported
          ? 'Imported from learner-provided text on this device.'
          : 'Learner-created content on this device.',
      'license': draft.imported
          ? 'Learner-supplied text; source rights not independently verified.'
          : 'User-created text; no external source license asserted.',
      'reviewedBy': draft.imported
          ? 'Imported by learner; independent language review not performed'
          : 'Learner; independent language review not performed',
      'reviewedOn': today,
      'reviewStatus': 'user-created',
      'audio': null,
      'questions': questions,
      'details': null,
      'customExplanation': draft.explanation.trim().isEmpty
          ? null
          : draft.explanation.trim(),
    };
    // The same lesson parser used by source content validates every linked
    // example and question before any database write occurs.
    VocabularyPack.parse(
      jsonEncode({
        'schemaVersion': 5,
        'id': 'custom.p$profile',
        'revision': 1,
        'words': [word],
      }),
    );
    final stored = {...word, 'ownerProfileId': profile};
    final search =
        '${draft.hanzi} ${draft.pinyin} ${draft.meaning} '
                '${PinyinInputEngine.normalize(draft.pinyin)}'
            .toLowerCase();
    await database.customStatement(
      '''
        INSERT INTO curriculum_words(id,pack_id,revision,content_schema,hanzi,pinyin,meaning,search_text,default_position,metadata_json)
        VALUES(?,?,?,?,?,?,?,?,?,?)
      ''',
      [
        id,
        'custom.p$profile',
        1,
        5,
        draft.hanzi.trim(),
        draft.pinyin.trim(),
        draft.meaning.trim(),
        search,
        -1,
        jsonEncode(stored),
      ],
    );
    for (var i = 0; i < 5; i++) {
      final sid = '$id.sentence.$i';
      final example = (word['examples'] as List)[i];
      await database.customStatement(
        'INSERT INTO curriculum_sentences(id,payload_json) VALUES(?,?)',
        [sid, jsonEncode(example)],
      );
      await database.customStatement(
        'INSERT INTO curriculum_examples(word_id,sentence_id,position) VALUES(?,?,?)',
        [id, sid, i],
      );
    }
    for (var i = 0; i < questions.length; i++) {
      await database.customStatement(
        'INSERT INTO curriculum_questions(id,word_id,position,payload_json) VALUES(?,?,?,?)',
        [questions[i]['id'], id, i, jsonEncode(questions[i])],
      );
    }
    await database.customStatement(
      'UPDATE learning_queue SET position=position+1 WHERE profile_id=?',
      [profile],
    );
    await database.customStatement(
      'INSERT INTO learning_queue(profile_id,word_id,position) VALUES(?,?,0)',
      [profile, id],
    );
    return QueueWord(
      id,
      draft.hanzi.trim(),
      draft.pinyin.trim(),
      draft.meaning.trim(),
    );
  }

  Future<QueuePage> page(
    int profile, {
    int offset = 0,
    String search = '',
    int? priority,
    WordCategory? category,
    bool priorityOrder = false,
  }) async {
    if (offset < 0 ||
        offset > 20000 ||
        search.length > 100 ||
        (priority != null && (priority < 0 || priority > 4)))
      throw ArgumentError('Invalid queue page.');
    await _queue(profile);
    final rows = await database
        .customSelect(
          '''
      SELECT w.id,w.hanzi,w.pinyin,w.meaning FROM learning_queue q
      JOIN curriculum_words w ON w.id=q.word_id
      WHERE q.profile_id=? AND instr(w.search_text,?)>0
      ${priority == null ? '' : "AND CASE WHEN w.pack_id LIKE 'custom.%' THEN 0 ELSE COALESCE(json_extract(w.metadata_json,'\$.details.learningPriority.tier'),4) END=?"}
      ${category == WordCategory.customWords
              ? "AND w.pack_id LIKE 'custom.%'"
              : category == null
              ? ''
              : "AND (${category.partsOfSpeech.map((_) => "instr(';' || replace(COALESCE(json_extract(w.metadata_json,'\$.details.partOfSpeech'),''),'; ',';') || ';', ?) > 0").join(' OR ')})"}
      AND NOT EXISTS (SELECT 1 FROM vocabulary_progress p WHERE p.profile_id=q.profile_id AND p.word_id=q.word_id)
      ORDER BY ${priorityOrder ? 'w.default_position' : 'q.position'},q.word_id LIMIT 21 OFFSET ?
    ''',
          variables: [
            Variable(profile),
            Variable(search.trim().toLowerCase()),
            if (priority != null) Variable(priority),
            if (category != null && category != WordCategory.customWords)
              ...category.partsOfSpeech.map((part) => Variable(';$part;')),
            Variable(offset),
          ],
        )
        .get();
    return QueuePage(
      List.unmodifiable(
        rows
            .take(20)
            .map(
              (r) => QueueWord(
                r.read<String>('id'),
                r.read<String>('hanzi'),
                r.read<String>('pinyin'),
                r.read<String>('meaning'),
              ),
            ),
      ),
      rows.length > 20,
    );
  }

  Future<void> move(int profile, String id, String direction) async {
    if (!{'up', 'down', 'front'}.contains(direction))
      throw ArgumentError('Invalid move.');
    await _queue(profile);
    await database.transaction(() async {
      final row =
          await (database.select(database.learningQueue)..where(
                (q) => q.profileId.equals(profile) & q.wordId.equals(id),
              ))
              .getSingle();
      final comparison = direction == 'down' ? '>' : '<';
      final order = direction == 'up' ? 'DESC' : 'ASC';
      final neighbor = await database
          .customSelect(
            '''
        SELECT q.word_id,q.position FROM learning_queue q WHERE q.profile_id=? AND q.position $comparison ?
        AND NOT EXISTS(SELECT 1 FROM vocabulary_progress p WHERE p.profile_id=q.profile_id AND p.word_id=q.word_id)
        ORDER BY q.position $order LIMIT 1
      ''',
            variables: [Variable(profile), Variable(row.position)],
          )
          .getSingleOrNull();
      if (neighbor == null) return;
      final target = neighbor.read<int>('position');
      if (direction == 'front') {
        await database.customStatement(
          'UPDATE learning_queue SET position=position+1 WHERE profile_id=? AND position>=? AND position<?',
          [profile, target, row.position],
        );
      } else {
        await database.customStatement(
          'UPDATE learning_queue SET position=? WHERE profile_id=? AND word_id=?',
          [row.position, profile, neighbor.read<String>('word_id')],
        );
      }
      await database.customStatement(
        'UPDATE learning_queue SET position=? WHERE profile_id=? AND word_id=?',
        [target, profile, id],
      );
    });
  }

  Future<void> reset(int profile) async {
    await _queue(profile);
    await database.customStatement(
      '''UPDATE learning_queue SET position=
      (SELECT default_position FROM curriculum_words w WHERE w.id=learning_queue.word_id) WHERE profile_id=?''',
      [profile],
    );
  }
}

final curriculumRepositoryProvider = Provider<CurriculumRepository>(
  (ref) => CurriculumRepository(ref.watch(appDatabaseProvider)),
);
