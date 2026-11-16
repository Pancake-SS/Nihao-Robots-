import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/grammar/grammar_repository.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('428 imported grammar lessons are paged and searchable', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Grammar'))).selected!.id;
    final repo = GrammarRepository(db);
    final first = await repo.page(profile, completed: false);
    expect(first.total, 428);
    expect(first.lessons, hasLength(20));
    expect(first.lessons.first.title, '主谓句1：动词谓语句');
    expect(first.lessons.first.level, 1);
    expect(
      (await repo.page(profile, completed: false, page: 1)).lessons,
      hasLength(20),
    );
    final searched = await repo.page(
      profile,
      completed: false,
      search: '正反问句',
      level: 1,
    );
    expect(searched.total, 1);
    final lesson = await repo.detail(profile, searched.lessons.single.id);
    expect(lesson!.pattern, contains('不'));
    expect(lesson.examples, hasLength(3));
    expect(lesson.allsetId, 'ASGZH7K3');
    expect(lesson.allsetUrl, contains('ASGZH7K3'));
    expect((await repo.categories()).length, 10);
    expect((await repo.counts(profile)).pending, 428);
  });

  test(
    'completion is profile-private, reversible and survives reopening',
    () async {
      final directory = await Directory.systemTemp.createTemp('nihao-grammar-');
      final file = File('${directory.path}/learner.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final profiles = SqliteProfileRepository(db);
      final first = (await profiles.create(const ProfileDraft(name: 'One')))
          .selected!
          .id;
      final second = (await profiles.create(const ProfileDraft(name: 'Two')))
          .selected!
          .id;
      final repo = GrammarRepository(db);
      final id = (await repo.page(first, completed: false)).lessons.first.id;
      await repo.setCompleted(first, id, true);
      final saved = await db.select(db.grammarProgress).get();
      expect(saved, hasLength(1));
      await repo.setCompleted(first, id, true);
      expect(
        (await db.select(db.grammarProgress).get()).single.completedAtMs,
        saved.single.completedAtMs,
      );
      expect((await repo.counts(first)).completed, 1);
      expect((await repo.counts(second)).completed, 0);
      expect((await repo.page(first, completed: true)).lessons.single.id, id);
      expect((await repo.page(second, completed: false)).total, 428);
      await db.close();

      final reopened = AppDatabase(NativeDatabase(file));
      try {
        final again = GrammarRepository(reopened);
        expect((await again.counts(first)).completed, 1);
        expect((await again.detail(first, id))!.completed, isTrue);
        await again.setCompleted(first, id, false);
        expect((await again.counts(first)).pending, 428);
        expect((await again.detail(first, id))!.completed, isFalse);
      } finally {
        await reopened.close();
        await directory.delete(recursive: true);
      }
    },
  );

  test('schema 7 upgrade adds grammar without losing a profile', () async {
    final directory = await Directory.systemTemp.createTemp('nihao-grammar-v7-');
    final file = File('${directory.path}/learner.sqlite');
    try {
      final previous = AppDatabase(NativeDatabase(file));
      final profile = (await SqliteProfileRepository(
        previous,
      ).create(const ProfileDraft(name: 'Before grammar'))).selected!.id;
      // Schema 8 only adds these tables, so removing them recreates a v7 shape.
      for (final name in [
        'grammar_progress',
        'grammar_examples',
        'grammar_installs',
        'grammar_lessons',
      ]) {
        await previous.customStatement('DROP TABLE $name');
      }
      await previous.customStatement('PRAGMA user_version = 7');
      await previous.close();

      final upgraded = AppDatabase(NativeDatabase(file));
      try {
        final repo = GrammarRepository(upgraded);
        expect((await repo.counts(profile)).pending, 428);
        final profiles = await upgraded.select(upgraded.profiles).get();
        expect(profiles.single.id, profile);
        expect(profiles.single.name, 'Before grammar');
        expect(
          (await upgraded.customSelect('PRAGMA user_version').getSingle())
              .read<int>('user_version'),
          8,
        );
      } finally {
        await upgraded.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
