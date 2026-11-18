import 'dart:convert';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/profile_archive.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';

void main() {
  test('account save restores private progress and custom content twice', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final profiles = SqliteProfileRepository(db);
    final original = (await profiles.create(const ProfileDraft(name: 'Reader')))
        .selected!
        .id;
    final oldPack = 'custom.p$original';
    final oldWord = '$oldPack.hello';
    final oldSentence = '$oldPack.sentence1';
    await db.customStatement(
      'INSERT INTO curriculum_words (id,pack_id,revision,content_schema,hanzi,pinyin,meaning,search_text,default_position,metadata_json) VALUES (?,?,?,?,?,?,?,?,?,?)',
      [
        oldWord,
        oldPack,
        1,
        3,
        '你好',
        'nǐ hǎo',
        'hello',
        '你好 hello',
        0,
        jsonEncode({'ownerProfileId': original}),
      ],
    );
    await db.customStatement(
      'INSERT INTO curriculum_sentences (id,payload_json) VALUES (?,?)',
      [
        oldSentence,
        jsonEncode({'hanzi': '你好！', 'source': oldPack}),
      ],
    );
    await db.customStatement(
      'INSERT INTO curriculum_examples (word_id,sentence_id,position) VALUES (?,?,0)',
      [oldWord, oldSentence],
    );
    await db.customStatement(
      'INSERT INTO curriculum_questions (id,word_id,position,payload_json) VALUES (?,?,0,?)',
      [
        '$oldPack.q1',
        oldWord,
        jsonEncode({'wordId': oldWord}),
      ],
    );
    await db.customStatement(
      'INSERT INTO learning_queue (profile_id,word_id,position) VALUES (?,?,0)',
      [original, oldWord],
    );
    await db.customStatement(
      'INSERT INTO practice_responses (id,profile_id,word_id,question_id,correct,answered_at_ms) VALUES (?,?,?,?,?,?)',
      ['one.answer', original, oldWord, '$oldPack.q1', 1, 1800000000000],
    );
    await db.customStatement(
      'INSERT INTO vocabulary_attempts (event_id,profile_id,word_id,pack_id,content_revision,version_before,is_review,answers_json,questions_json,passed,answered_at_ms,next_due_at_ms,next_stage) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
      [
        List.filled(32, 'a').join(),
        original,
        oldWord,
        oldPack,
        1,
        0,
        0,
        jsonEncode({'$oldPack.q1': '$oldPack.option1'}),
        jsonEncode([
          {
            'id': '$oldPack.q1',
            'options': {'$oldPack.option1': '你好'},
          },
        ]),
        1,
        1800000000000,
        1800000000000,
        'learning',
      ],
    );
    await db.customStatement(
      'INSERT INTO master_writings (id,profile_id,word_id,prompt,sentence,written_at_ms) VALUES (?,?,?,?,?,?)',
      ['one.writing', original, oldWord, 'Write a story', '你好！', 1800000000000],
    );
    await db.customStatement(
      'INSERT INTO learning_entries (profile_id,kind,title,prompt,hanzi,pinyin,english,created_at_ms,updated_at_ms) VALUES (?,?,?,?,?,?,?,?,?)',
      [
        original,
        'note',
        'Ideas',
        '',
        '中文 and English',
        '',
        '',
        1800000000000,
        1800000000000,
      ],
    );

    final archive = ProfileArchiveRepository(db);
    final saved = await archive.exportProfile(original);
    final first = await archive.importProfile(saved);
    final second = await archive.importProfile(saved);
    expect({first, second, original}, hasLength(3));
    for (final profileId in [first, second]) {
      final pack = 'custom.p$profileId';
      final words = await db
          .customSelect(
            'SELECT id,metadata_json FROM curriculum_words WHERE pack_id=?',
            variables: [Variable.withString(pack)],
          )
          .get();
      expect(words, hasLength(1));
      expect(words.single.read<String>('id'), '$pack.hello');
      expect(
        jsonDecode(
          words.single.read<String>('metadata_json'),
        )['ownerProfileId'],
        profileId,
      );
      final sentences = await db.select(db.curriculumSentences).get();
      expect(
        sentences.where((row) => row.id == '$pack.sentence1'),
        hasLength(1),
      );
      final questions = await db.select(db.curriculumQuestions).get();
      expect(
        questions.where((row) => row.wordId == '$pack.hello'),
        hasLength(1),
      );
      final attempt = (await db.select(db.vocabularyAttempts).get())
          .singleWhere((row) => row.profileId == profileId);
      expect(jsonDecode(attempt.answersJson), {'$pack.q1': '$pack.option1'});
      expect((jsonDecode(attempt.questionsJson) as List).single['options'], {
        '$pack.option1': '你好',
      });
      final queue = await db.select(db.learningQueue).get();
      expect(
        queue.where((row) => row.profileId == profileId).single.wordId,
        '$pack.hello',
      );
      final notes = await db.select(db.learningEntries).get();
      expect(
        notes.where((row) => row.profileId == profileId).single.hanzi,
        '中文 and English',
      );
    }
    final responses = await db.select(db.practiceResponses).get();
    expect(responses, hasLength(3));
    expect(responses.map((row) => row.id).toSet(), hasLength(3));
    final writings = await db.select(db.masterWritings).get();
    expect(writings.map((row) => row.id).toSet(), hasLength(3));

    final before = (await db.select(db.profiles).get()).length;
    final damaged = jsonDecode(saved) as Map<String, dynamic>;
    (damaged['payload'] as Map<String, dynamic>)['profile']['name'] = 'Changed';
    await expectLater(
      archive.importProfile(jsonEncode(damaged)),
      throwsA(isA<FormatException>()),
    );
    expect((await db.select(db.profiles).get()).length, before);
    await db.close();

    final freshDb = AppDatabase(NativeDatabase.memory());
    addTearDown(freshDb.close);
    final restoredId = await ProfileArchiveRepository(freshDb)
        .importProfile(saved);
    expect(
      (await freshDb.select(freshDb.profiles).get()).single.id,
      restoredId,
    );
    expect(
      (await freshDb.select(freshDb.curriculumWords).get()).single.id,
      'custom.p$restoredId.hello',
    );
    expect(
      (await freshDb.select(freshDb.learningEntries).get()).single.hanzi,
      '中文 and English',
    );
  });
}
