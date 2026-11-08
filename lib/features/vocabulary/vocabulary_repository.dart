import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database_provider.dart';
import 'content_pack.dart';
import 'sqlite_vocabulary_repository.dart';
import 'learning_priority.dart';
import 'curriculum_repository.dart';
import 'word_teaching.dart';

class CatalogueWord {
  const CatalogueWord(
    this.packId,
    this.revision,
    this.entry, {
    this.teaching = const [],
  });
  final String packId;
  final int revision;
  final VocabularyEntry entry;
  final List<TeachingSense> teaching;
}

abstract interface class VocabularyRepository {
  Future<List<CatalogueWord>> load();
}

abstract interface class WordLookupRepository {
  Future<CatalogueWord?> lookup(String id);
}

class FullVocabularyRepository
    implements VocabularyRepository, WordLookupRepository {
  FullVocabularyRepository(this.starter, this.curriculum);
  final VocabularyRepository starter;
  final CurriculumRepository curriculum;
  @override
  Future<List<CatalogueWord>> load() => starter.load();
  @override
  Future<CatalogueWord?> lookup(String id) => curriculum.lesson(id);
}

class BundledVocabularyRepository implements VocabularyRepository {
  BundledVocabularyRepository(this.bundle, List<String> assetPaths)
    : _assetPaths = List.unmodifiable(assetPaths);
  final AssetBundle bundle;
  final List<String> _assetPaths;

  @override
  Future<List<CatalogueWord>> load() async {
    return List.unmodifiable([
      for (final pack in await loadPacks())
        for (final entry in pack.entries)
          CatalogueWord(pack.id, pack.revision, entry),
    ]);
  }

  Future<List<VocabularyPack>> loadPacks() async {
    final packs = <String>{};
    final senses = <String>{};
    final validated = <VocabularyPack>[];
    // Paths are an application-owned allowlist, never user-supplied URLs.
    // Publish only after every pack validates, so a later failure cannot expose
    // an incomplete catalogue or silently choose between conflicting revisions.
    for (final path in _assetPaths) {
      final pack = VocabularyPack.parse(await bundle.loadString(path));
      if (!packs.add(pack.id))
        throw const FormatException('Duplicate pack ID.');
      for (final entry in pack.entries) {
        if (!senses.add(entry.id))
          throw const FormatException('Conflicting word ID.');
      }
      validated.add(pack);
    }
    return List.unmodifiable(validated);
  }
}

final vocabularyRepositoryProvider = Provider<VocabularyRepository>(
  (ref) => FullVocabularyRepository(
    SqliteVocabularyRepository(
      ref.watch(appDatabaseProvider),
      BundledVocabularyRepository(rootBundle, const [
        'assets/content/starter_greeting_v2.json',
        'assets/content/starter_imported_v1.json',
      ]),
    ),
    ref.watch(curriculumRepositoryProvider),
  ),
);

final vocabularyLessonProvider = FutureProvider.family<CatalogueWord?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(vocabularyRepositoryProvider);
  if (repository is WordLookupRepository)
    return (repository as WordLookupRepository).lookup(id);
  return (await repository.load()).where((w) => w.entry.id == id).firstOrNull;
}, retry: (_, _) => null);

final vocabularyCatalogueProvider = FutureProvider<List<CatalogueWord>>((
  ref,
) async {
  final words = [...await ref.watch(vocabularyRepositoryProvider).load()];
  words.sort(
    (a, b) => LearningPriority.compare(
      a.entry.details?.learningPriority,
      a.entry.details?.band,
      a.entry.id,
      b.entry.details?.learningPriority,
      b.entry.details?.band,
      b.entry.id,
    ),
  );
  return List.unmodifiable(words);
}, retry: (_, _) => null);
