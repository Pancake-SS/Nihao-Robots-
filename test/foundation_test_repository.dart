import 'dart:async';

import 'package:ni_hao_robot/features/onboarding/foundation_repository.dart';

class TestFoundationRepository implements FoundationRepository {
  final states = <int, FoundationState>{};
  bool failLoad = false;
  bool failSave = false;
  Completer<void>? saveGate;
  int saves = 0;

  @override
  Future<FoundationState> load(int profileId) async {
    if (failLoad) throw StateError('Test read error');
    return states[profileId] ?? const FoundationState();
  }

  @override
  Future<FoundationState> save(
    int profileId,
    int step, {
    bool complete = false,
  }) async {
    saves++;
    await saveGate?.future;
    if (failSave) throw StateError('Test write error');
    return states[profileId] = FoundationState(
      step: step,
      completed: complete || (states[profileId]?.completed ?? false),
    );
  }
}
