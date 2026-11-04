import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'content_pack.dart';

class CatalogueWord {
  const CatalogueWord(this.packId, this.revision, this.entry);
  final String packId;
  final int revision;
  final VocabularyEntry entry;
}

abstract interface class VocabularyRepository {
  Future<List<CatalogueWord>> load();
}

class BundledVocabularyRepository implements VocabularyRepository {
  BundledVocabularyRepository(this.bundle, List<String> assetPaths)
    : _assetPaths = List.unmodifiable(assetPaths);
  final AssetBundle bundle;
  final List<String> _assetPaths;

  @override
  Future<List<CatalogueWord>> load() async {
    final packs = <String>{};
    final senses = <String>{};
    final words = <CatalogueWord>[];
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
        words.add(CatalogueWord(pack.id, pack.revision, entry));
      }
    }
    return List.unmodifiable(words);
  }
}

final vocabularyRepositoryProvider = Provider<VocabularyRepository>(
  (ref) => BundledVocabularyRepository(rootBundle, const [
    'assets/content/starter_greeting_v1.json',
  ]),
);

final vocabularyCatalogueProvider = FutureProvider<List<CatalogueWord>>(
  (ref) => ref.watch(vocabularyRepositoryProvider).load(),
  retry: (_, _) => null,
);
