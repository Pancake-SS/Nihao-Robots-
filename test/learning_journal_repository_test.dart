import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/learning/learning_journal_repository.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';

void main() {
  const writing = LearningEntryDraft(
    kind: LearningEntryKind.writing,
    title: 'A rainy day',
    prompt: 'Describe your ideal rainy day.',
    hanzi: '今天下雨了。',
    pinyin: 'Jīntiān xià yǔ le.',
    english: 'It rained today.',
  );

  test('writing and notes stay private, editable and durable', () async {
    final directory = await Directory.systemTemp.createTemp('nihao-learning-');
    final file = File('${directory.path}/learner.sqlite');
    try {
      final db = AppDatabase(NativeDatabase(file));
      final profiles = SqliteProfileRepository(db);
      final first = (await profiles.create(const ProfileDraft(name: 'One')))
          .selected!
          .id;
      final second = (await profiles.create(const ProfileDraft(name: 'Two')))
          .selected!
          .id;
      final repo = LearningJournalRepository(db);
      final writingId = await repo.save(first, writing);
      final noteId = await repo.save(
        first,
        const LearningEntryDraft(
          kind: LearningEntryKind.note,
          title: 'Useful phrase',
          hanzi: '慢慢来',
          pinyin: 'mànmàn lái',
          english: 'Take it slowly',
        ),
      );
      expect(await repo.count(first, LearningEntryKind.writing), 1);
      expect(await repo.count(first, LearningEntryKind.note), 1);
      expect(await repo.count(second, LearningEntryKind.note), 0);
      expect(
        (await repo.list(first, LearningEntryKind.note)).single.id,
        noteId,
      );
      expect(await repo.count(first, LearningEntryKind.note, search: '慢慢'), 1);
      expect(await repo.get(second, writingId), isNull);
      expect(() => repo.save(second, writing, id: writingId), throwsStateError);
      expect(await repo.delete(second, noteId), isFalse);
      expect((await repo.get(first, noteId))!.hanzi, '慢慢来');
      await repo.save(
        first,
        const LearningEntryDraft(
          kind: LearningEntryKind.note,
          title: 'Useful phrase',
          hanzi: '慢慢来！',
          pinyin: '',
          english: 'No rush',
        ),
        id: noteId,
      );
      await db.close();

      final reopened = AppDatabase(NativeDatabase(file));
      try {
        final again = LearningJournalRepository(reopened);
        expect((await again.get(first, writingId))!.prompt, writing.prompt);
        expect((await again.get(first, noteId))!.hanzi, '慢慢来！');
        expect(await again.count(second, LearningEntryKind.writing), 0);
        expect(await again.delete(first, noteId), isTrue);
        expect(await again.count(first, LearningEntryKind.note), 0);
      } finally {
        await reopened.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });

  test('blank entries and mismatched kinds are rejected', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Writer'))).selected!.id;
    final repo = LearningJournalRepository(db);
    expect(
      () => repo.save(
        profile,
        const LearningEntryDraft(
          kind: LearningEntryKind.note,
          title: 'Empty',
          hanzi: '',
          pinyin: '',
          english: '',
        ),
      ),
      throwsArgumentError,
    );
    final id = await repo.save(profile, writing);
    expect(
      () => repo.save(
        profile,
        const LearningEntryDraft(
          kind: LearningEntryKind.note,
          title: 'Wrong kind',
          hanzi: '你好',
          pinyin: '',
          english: '',
        ),
        id: id,
      ),
      throwsStateError,
    );
    expect((await repo.get(profile, id))!.kind, 'writing');
  });

  test('schema 8 upgrades without losing a saved profile', () async {
    final directory = await Directory.systemTemp.createTemp(
      'nihao-learning-v8-',
    );
    final file = File('${directory.path}/learner.sqlite');
    try {
      final old = AppDatabase(NativeDatabase(file));
      final profile = (await SqliteProfileRepository(
        old,
      ).create(const ProfileDraft(name: 'Existing learner'))).selected!.id;
      // Schema 9 only adds learning_entries; remove it to recreate a v8 shape.
      await old.customStatement('DROP TABLE learning_entries');
      await old.customStatement('PRAGMA user_version = 8');
      await old.close();

      final upgraded = AppDatabase(NativeDatabase(file));
      try {
        final repo = LearningJournalRepository(upgraded);
        expect(await repo.count(profile, LearningEntryKind.note), 0);
        expect(
          (await upgraded.select(upgraded.profiles).get()).single.name,
          'Existing learner',
        );
        expect(
          (await upgraded.customSelect('PRAGMA user_version').getSingle())
              .read<int>('user_version'),
          9,
        );
      } finally {
        await upgraded.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
