import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';

void main() {
  late AppDatabase database;
  late SqliteProfileRepository repository;
  var initialDatabaseClosed = false;
  final now = DateTime.utc(2026, 11, 3, 4);

  setUp(() {
    initialDatabaseClosed = false;
    database = AppDatabase(NativeDatabase.memory());
    repository = SqliteProfileRepository(database, now: () => now);
  });
  tearDown(() async {
    if (!initialDatabaseClosed) await database.close();
  });

  test('fresh database has no invented profiles or selection', () async {
    final snapshot = await repository.load();
    expect(snapshot.profiles, isEmpty);
    expect(snapshot.selected, isNull);
  });

  test(
    'profile creation saves its own settings and injected UTC timestamp',
    () async {
      final snapshot = await repository.create(
        const ProfileDraft(
          name: '  小明  ',
          level: LearnerLevel.basics,
          goal: LearningGoal.travel,
          dailyMinutes: 10,
          showPinyin: false,
        ),
      );
      final profile = snapshot.selected!;
      expect(profile.name, '小明');
      expect(profile.createdAt, now);
      expect(profile.createdAt.isUtc, isTrue);
      expect(profile.level, LearnerLevel.basics);
      expect(profile.goal, LearningGoal.travel);
      expect(profile.dailyMinutes, 10);
      expect(profile.showPinyin, isFalse);
    },
  );

  test(
    'duplicate display names keep independent identities and settings',
    () async {
      final first = (await repository.create(const ProfileDraft(name: 'Mei')))
          .selected!;
      final second = (await repository.create(
        const ProfileDraft(
          name: 'Mei',
          dailyMinutes: 20,
          goal: LearningGoal.reading,
          showPinyin: false,
        ),
      )).selected!;
      expect(first.id, isNot(second.id));
      final selected = await repository.select(first.id);
      expect(selected.selected!.dailyMinutes, 5);
      expect(selected.profiles.last.dailyMinutes, 20);
      expect(selected.profiles.last.showPinyin, isFalse);
    },
  );

  test(
    'SQL-looking input is stored as text without changing the schema',
    () async {
      const name = "Mei'); DROP TABLE profiles;--";
      await repository.create(const ProfileDraft(name: name));
      expect((await repository.load()).selected!.name, name);
      await repository.create(const ProfileDraft(name: 'Another'));
      expect((await repository.load()).profiles, hasLength(2));
    },
  );

  test(
    'invalid requests preserve the existing profile and selection',
    () async {
      final original = await repository.create(const ProfileDraft(name: 'Mei'));
      await expectLater(
        Future.sync(
          () => repository.create(const ProfileDraft(name: '\u0000')),
        ),
        throwsFormatException,
      );
      await expectLater(repository.select(9999), throwsStateError);
      final after = await repository.load();
      expect(after.profiles, hasLength(1));
      expect(after.selectedId, original.selectedId);
    },
  );

  test(
    'foreign keys and daily goal constraints reject invalid persisted state',
    () async {
      await repository.load();
      await expectLater(
        database
            .into(database.appPreferences)
            .insert(
              AppPreferencesCompanion.insert(
                id: const Value(1),
                selectedProfileId: 999,
              ),
            ),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        database
            .into(database.profiles)
            .insert(
              ProfilesCompanion.insert(
                name: 'Mei',
                level: 'beginner',
                goal: 'reading',
                dailyMinutes: -1,
                showPinyin: true,
                createdAt: now,
              ),
            ),
        throwsA(isA<Exception>()),
      );
      expect((await repository.load()).profiles, isEmpty);
    },
  );

  test(
    'failed selection write rolls back the entire profile creation',
    () async {
      await repository.load();
      await database.customStatement(
        '''CREATE TRIGGER reject_selection BEFORE INSERT ON app_preferences
      BEGIN SELECT RAISE(ABORT, 'test write failure'); END''',
      );
      await expectLater(
        repository.create(const ProfileDraft(name: 'Mei')),
        throwsA(isA<Exception>()),
      );
      expect((await repository.load()).profiles, isEmpty);
    },
  );

  test(
    'two profiles and last choice survive closing and reopening the file',
    () async {
      await database.close();
      initialDatabaseClosed = true;
      final directory = await Directory.systemTemp.createTemp(
        'nihao-profile-test-',
      );
      final file = File(
        '${directory.path}${Platform.pathSeparator}profiles.sqlite',
      );
      AppDatabase? firstConnection;
      AppDatabase? secondConnection;
      try {
        firstConnection = AppDatabase(NativeDatabase(file));
        final firstRepository = SqliteProfileRepository(
          firstConnection,
          now: () => now,
        );
        final first = (await firstRepository.create(
          const ProfileDraft(name: 'Mei'),
        )).selected!;
        await firstRepository.create(
          const ProfileDraft(name: '小明', dailyMinutes: 15),
        );
        await firstRepository.select(first.id);
        await firstConnection.close();
        firstConnection = null;
        secondConnection = AppDatabase(NativeDatabase(file));
        final reopened = await SqliteProfileRepository(secondConnection).load();
        expect(reopened.profiles.map((profile) => profile.name), ['Mei', '小明']);
        expect(reopened.selectedId, first.id);
        expect(reopened.profiles.last.dailyMinutes, 15);
        expect(reopened.profiles.first.createdAt, now);
      } finally {
        await firstConnection?.close();
        await secondConnection?.close();
        final temporaryRoot = Directory.systemTemp.absolute.path;
        if (!directory.absolute.path.startsWith(
          '$temporaryRoot${Platform.pathSeparator}nihao-profile-test-',
        )) {
          throw StateError('Unexpected test cleanup path.');
        }
        await directory.delete(recursive: true);
      }
    },
  );
}
