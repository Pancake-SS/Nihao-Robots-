import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/open_database.dart';
import 'profile.dart';
import 'sqlite_profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final database = openAppDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return SqliteProfileRepository(database);
});

final profilesProvider =
    AsyncNotifierProvider<ProfilesController, ProfileSnapshot>(
      ProfilesController.new,
      retry: (_, _) => null,
    );

class ProfilesController extends AsyncNotifier<ProfileSnapshot> {
  bool _saving = false;

  @override
  Future<ProfileSnapshot> build() =>
      ref.watch(profileRepositoryProvider).load();

  Future<void> create(ProfileDraft draft) =>
      _save(() => ref.read(profileRepositoryProvider).create(draft));

  Future<void> select(int id) =>
      _save(() => ref.read(profileRepositoryProvider).select(id));

  Future<void> _save(Future<ProfileSnapshot> Function() action) async {
    if (_saving) throw StateError('A profile save is already in progress.');
    _saving = true;
    try {
      final snapshot = await action();
      if (ref.mounted) state = AsyncData(snapshot);
    } finally {
      _saving = false;
    }
  }
}
