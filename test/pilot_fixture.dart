import 'dart:io';

import 'package:ni_hao_robot/features/vocabulary/content_pack.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';

CatalogueWord loadPilot() {
  final pack = VocabularyPack.parse(
    File('assets/content/starter_greeting_v1.json').readAsStringSync(),
  );
  return CatalogueWord(pack.id, pack.revision, pack.entries.single);
}

Map<String, String> correctAnswers(CatalogueWord word) => {
  for (final q in word.entry.questions) q.id: q.correctOptionId,
};
