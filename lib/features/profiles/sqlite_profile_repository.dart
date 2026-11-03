import 'package:drift/drift.dart';

import '../../data/app_database.dart';
import 'profile.dart';

class SqliteProfileRepository implements ProfileRepository {
  SqliteProfileRepository(this.database, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase database;
  final DateTime Function() _now;

  @override
  Future<ProfileSnapshot> load() => database.transaction(_load);

  Future<ProfileSnapshot> _load() async {
    final rows = await (database.select(
      database.profiles,
    )..orderBy([(row) => OrderingTerm.asc(row.id)])).get();
    final preference = await database
        .select(database.appPreferences)
        .getSingleOrNull();
    final profiles = rows.map((row) {
      // Invalid disk contents produce a recoverable error, never guessed settings.
      final level = LearnerLevel.values.byName(row.level);
      final goal = LearningGoal.values.byName(row.goal);
      final draft = ProfileDraft(
        name: row.name,
        dailyMinutes: row.dailyMinutes,
      );
      draft.validatedName;
      return LearnerProfile(
        id: row.id,
        name: row.name,
        level: level,
        goal: goal,
        dailyMinutes: row.dailyMinutes,
        showPinyin: row.showPinyin,
        createdAt: row.createdAt.toUtc(),
      );
    }).toList();
    final selectedId = preference?.selectedProfileId;
    if (selectedId != null &&
        !profiles.any((profile) => profile.id == selectedId)) {
      throw StateError('Selected profile is unavailable.');
    }
    return ProfileSnapshot(profiles: profiles, selectedId: selectedId);
  }

  @override
  Future<ProfileSnapshot> create(ProfileDraft draft) {
    final name = draft.validatedName;
    return database.transaction(() async {
      final id = await database
          .into(database.profiles)
          .insert(
            ProfilesCompanion.insert(
              name: name,
              level: draft.level.name,
              goal: draft.goal.name,
              dailyMinutes: draft.dailyMinutes,
              showPinyin: draft.showPinyin,
              createdAt: _now().toUtc(),
            ),
          );
      await _saveSelection(id);
      return _load();
    });
  }

  @override
  Future<ProfileSnapshot> select(int profileId) {
    return database.transaction(() async {
      final exists = await (database.select(
        database.profiles,
      )..where((row) => row.id.equals(profileId))).getSingleOrNull();
      if (exists == null) throw StateError('Profile no longer exists.');
      await _saveSelection(profileId);
      return _load();
    });
  }

  Future<void> _saveSelection(int id) async {
    await database
        .into(database.appPreferences)
        .insertOnConflictUpdate(
          AppPreferencesCompanion.insert(
            id: const Value(1),
            selectedProfileId: id,
          ),
        );
  }
}
