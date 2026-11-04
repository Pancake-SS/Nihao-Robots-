import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import '../vocabulary/vocabulary_repository.dart';
import 'learning.dart';
import 'sqlite_learning_repository.dart';

final learningClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);
final learningRepositoryProvider = Provider<LearningRepository>(
  (ref) => SqliteLearningRepository(
    ref.watch(appDatabaseProvider),
    now: ref.watch(learningClockProvider),
    catalogue: () => ref.read(vocabularyCatalogueProvider.future),
  ),
);
final learningProgressProvider = FutureProvider.family<List<WordProgress>, int>(
  (ref, id) => ref.watch(learningRepositoryProvider).progress(id),
  retry: (_, _) => null,
);
