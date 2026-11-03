import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'open_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = openAppDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});
