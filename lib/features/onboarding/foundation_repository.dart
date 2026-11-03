import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';

const foundationStepCount = 9;

class FoundationState {
  const FoundationState({this.step = 0, this.completed = false});
  final int step;
  final bool completed;
}

abstract interface class FoundationRepository {
  Future<FoundationState> load(int profileId);
  Future<FoundationState> save(
    int profileId,
    int step, {
    bool complete = false,
  });
}

class SqliteFoundationRepository implements FoundationRepository {
  SqliteFoundationRepository(this.database);
  final AppDatabase database;

  @override
  Future<FoundationState> load(int profileId) async {
    final profile = await (database.select(
      database.profiles,
    )..where((row) => row.id.equals(profileId))).getSingleOrNull();
    if (profile == null) throw StateError('Profile is unavailable.');
    final row = await (database.select(
      database.foundationProgress,
    )..where((row) => row.profileId.equals(profileId))).getSingleOrNull();
    if (row == null) return const FoundationState();
    _validate(row.step);
    return FoundationState(step: row.step, completed: row.completed);
  }

  @override
  Future<FoundationState> save(
    int profileId,
    int step, {
    bool complete = false,
  }) {
    _validate(step);
    if (complete && step != foundationStepCount - 1) {
      throw ArgumentError('Completion requires the final introduction page.');
    }
    return database.transaction(() async {
      final previous = await load(profileId);
      // Replaying or going back never erases a completion record.
      final completed = previous.completed || complete;
      await database
          .into(database.foundationProgress)
          .insertOnConflictUpdate(
            FoundationProgressCompanion.insert(
              profileId: Value(profileId),
              step: step,
              completed: completed,
            ),
          );
      return FoundationState(step: step, completed: completed);
    });
  }

  void _validate(int step) {
    if (step < 0 || step >= foundationStepCount) {
      throw ArgumentError.value(step, 'step');
    }
  }
}

final foundationRepositoryProvider = Provider<FoundationRepository>(
  (ref) => SqliteFoundationRepository(ref.watch(appDatabaseProvider)),
);

final foundationStateProvider = FutureProvider.family<FoundationState, int>(
  (ref, profileId) => ref.watch(foundationRepositoryProvider).load(profileId),
  retry: (_, _) => null,
);
