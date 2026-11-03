import 'dart:async';

import 'package:ni_hao_robot/features/profiles/profile.dart';

class TestProfileRepository implements ProfileRepository {
  ProfileSnapshot snapshot = ProfileSnapshot(profiles: []);
  bool failLoad = false;
  bool failSave = false;
  Completer<void>? saveGate;
  int creates = 0;

  @override
  Future<ProfileSnapshot> load() async {
    if (failLoad) throw StateError('test storage failure');
    return snapshot;
  }

  @override
  Future<ProfileSnapshot> create(ProfileDraft draft) async {
    creates++;
    await saveGate?.future;
    if (failSave) throw StateError('test save failure');
    final id = snapshot.profiles.length + 1;
    final profile = LearnerProfile(
      id: id,
      name: draft.validatedName,
      level: draft.level,
      goal: draft.goal,
      dailyMinutes: draft.dailyMinutes,
      showPinyin: draft.showPinyin,
      createdAt: DateTime.utc(2026, 11, 3),
    );
    snapshot = ProfileSnapshot(
      profiles: [...snapshot.profiles, profile],
      selectedId: id,
    );
    return snapshot;
  }

  @override
  Future<ProfileSnapshot> select(int profileId) async {
    if (failSave) throw StateError('test save failure');
    snapshot = ProfileSnapshot(
      profiles: snapshot.profiles,
      selectedId: profileId,
    );
    return snapshot;
  }
}
