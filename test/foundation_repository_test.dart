import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/onboarding/foundation_content.dart';
import 'package:ni_hao_robot/features/onboarding/foundation_repository.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';

// Construct an actual v1 file from the committed, immutable schema snapshot.
class _VersionOneFixture extends AppDatabase {
  _VersionOneFixture(super.executor);
  @override
  int get schemaVersion => 1;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) async {
      final schema = jsonDecode(
        File('docs/schema/drift_schema_v1.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      for (final entity in schema['fixed_sql'] as List) {
        for (final sql in entity['sql'] as List) {
          if (sql['dialect'] == 'sqlite')
            await customStatement(sql['sql'] as String);
        }
      }
    },
  );
}

void main() {
  late AppDatabase database;
  late SqliteFoundationRepository repository;
  late int first;
  late int second;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = SqliteFoundationRepository(database);
    final profiles = SqliteProfileRepository(database);
    first = (await profiles.create(const ProfileDraft(name: 'Mei')))
        .selected!
        .id;
    second = (await profiles.create(const ProfileDraft(name: 'Mei')))
        .selected!
        .id;
  });
  tearDown(() => database.close());

  test(
    'new profiles start independently and navigation preserves completion',
    () async {
      expect(foundationPages.length, foundationStepCount);
      expect((await repository.load(first)).completed, isFalse);
      await repository.save(first, 4);
      expect((await repository.load(second)).step, 0);
      await repository.save(first, 8, complete: true);
      await repository.save(first, 1);
      expect((await repository.load(first)).completed, isTrue);
      expect((await repository.load(first)).step, 1);
      expect((await repository.load(second)).completed, isFalse);
    },
  );

  test(
    'invalid positions and missing profile do not mutate progress',
    () async {
      await repository.save(first, 3);
      for (final step in [-1, 9]) {
        expect(() => repository.save(first, step), throwsArgumentError);
      }
      expect(
        () => repository.save(first, 2, complete: true),
        throwsArgumentError,
      );
      await expectLater(repository.save(999, 1), throwsStateError);
      await expectLater(repository.load(999), throwsStateError);
      expect((await repository.load(first)).step, 3);
    },
  );

  test('database rejects out-of-range and orphan onboarding rows', () async {
    await expectLater(
      database
          .into(database.foundationProgress)
          .insert(
            FoundationProgressCompanion.insert(
              profileId: Value(first),
              step: 9,
              completed: false,
            ),
          ),
      throwsA(isA<Exception>()),
    );
    await expectLater(
      database
          .into(database.foundationProgress)
          .insert(
            FoundationProgressCompanion.insert(
              profileId: const Value(999),
              step: 1,
              completed: false,
            ),
          ),
      throwsA(isA<Exception>()),
    );
    expect(await database.select(database.foundationProgress).get(), isEmpty);
  });

  test(
    'write failure rolls back and retry retains the previous place',
    () async {
      await repository.save(first, 3);
      await database.customStatement(
        "CREATE TRIGGER reject_foundation BEFORE UPDATE ON foundation_progress BEGIN SELECT RAISE(ABORT, 'test'); END",
      );
      await expectLater(
        repository.save(first, 8, complete: true),
        throwsA(isA<Exception>()),
      );
      expect((await repository.load(first)).step, 3);
      expect((await repository.load(first)).completed, isFalse);
      await database.customStatement('DROP TRIGGER reject_foundation');
      await repository.save(first, 8, complete: true);
      expect((await repository.load(first)).completed, isTrue);
    },
  );

  test('v1 migration, restart and closed-file backup restoration preserve profiles', () async {
    // Avoid multiple open instances of the same generated database class.
    await database.close();
    final directory = await Directory.systemTemp.createTemp(
      'nihao-migration-test-',
    );
    final file = File('${directory.path}/learner.sqlite');
    AppDatabase? connection;
    try {
      connection = _VersionOneFixture(NativeDatabase(file));
      final oldProfiles = SqliteProfileRepository(connection);
      final a = (await oldProfiles.create(
        const ProfileDraft(name: '小明', showPinyin: false, dailyMinutes: 20),
      )).selected!;
      final b = (await oldProfiles.create(
        const ProfileDraft(name: 'Mei', goal: LearningGoal.travel),
      )).selected!;
      await oldProfiles.select(a.id);
      await connection.close();
      connection = null;
      final backup = await file.copy('${directory.path}/before-v2.sqlite');

      connection = AppDatabase(NativeDatabase(file));
      final migrated = await SqliteProfileRepository(connection).load();
      expect(migrated.selectedId, a.id);
      expect(migrated.profiles.map((p) => p.name), ['小明', 'Mei']);
      expect(migrated.selected!.dailyMinutes, 20);
      expect(migrated.selected!.showPinyin, isFalse);
      expect(migrated.selected!.createdAt, a.createdAt);
      final progress = SqliteFoundationRepository(connection);
      await progress.save(a.id, 8, complete: true);
      await progress.save(b.id, 4);
      expect(
        await connection.customSelect('PRAGMA foreign_key_check').get(),
        isEmpty,
      );
      await connection.close();

      connection = AppDatabase(NativeDatabase(file));
      expect(
        (await SqliteFoundationRepository(connection).load(a.id)).completed,
        isTrue,
      );
      expect((await SqliteFoundationRepository(connection).load(b.id)).step, 4);
      expect(
        (await SqliteProfileRepository(connection).load()).selectedId,
        a.id,
      );
      await connection.close();

      // Open the retained backup separately; never overwrite the migrated file.
      connection = AppDatabase(NativeDatabase(backup));
      final restored = await SqliteProfileRepository(connection).load();
      expect(restored.profiles.map((p) => p.id), [a.id, b.id]);
      expect(restored.selected!.name, '小明');
      expect(
        (await SqliteFoundationRepository(connection).load(a.id)).completed,
        isFalse,
      );
    } finally {
      await connection?.close();
      final prefix =
          '${Directory.systemTemp.absolute.path}${Platform.pathSeparator}nihao-migration-test-';
      if (!directory.absolute.path.startsWith(prefix))
        throw StateError('Unexpected cleanup path');
      await directory.delete(recursive: true);
      // Shared teardown closes this fresh in-memory instance.
      database = AppDatabase(NativeDatabase.memory());
    }
  });
}
