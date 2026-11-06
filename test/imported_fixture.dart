import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ni_hao_robot/features/vocabulary/content_pack.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';

const starterPaths = [
  'assets/content/starter_greeting_v2.json',
  'assets/content/starter_imported_v1.json',
];

class ContentTestBundle extends CachingAssetBundle {
  ContentTestBundle([Map<String, String>? files])
    : files =
          files ??
          {
            for (final path in starterPaths)
              path: File(path).readAsStringSync(),
          };
  final Map<String, String> files;
  @override
  Future<ByteData> load(String key) =>
      throw UnsupportedError('String fixture only');
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (!files.containsKey(key)) throw StateError('Missing content fixture');
    return files[key]!;
  }
}

CatalogueWord loadExpandedGreeting() {
  final pack = VocabularyPack.parse(
    File(starterPaths.first).readAsStringSync(),
  );
  return CatalogueWord(pack.id, pack.revision, pack.entries.single);
}
