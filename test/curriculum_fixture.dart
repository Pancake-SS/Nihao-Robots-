import 'dart:convert';
import 'dart:io';

import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/vocabulary/curriculum_repository.dart';
import 'package:ni_hao_robot/features/vocabulary/vocabulary_repository.dart';

CurriculumRepository fullCurriculum(AppDatabase db) => CurriculumRepository(
  db,
  seedFile: File('assets/content/curriculum.sqlite'),
  manifest: jsonDecode(
    File('assets/content/curriculum.manifest.json').readAsStringSync(),
  ) as Map<String, dynamic>,
);

// Existing onboarding/navigation tests only need the small prepared catalogue.
class StarterQueueFixture extends CurriculumRepository {
  StarterQueueFixture(super.database, this.starter);
  final VocabularyRepository starter;
  @override
  Future<QueuePage> page(
    int profile, {
    int offset = 0,
    String search = '',
    int? priority,
    WordCategory? category,
    bool priorityOrder = false,
  }) async {
    final words = (await starter.load())
        .where(
          (w) => '${w.entry.hanzi} ${w.entry.pinyin} ${w.entry.meaning}'
              .contains(search),
        )
        .toList();
    return QueuePage(
      words
          .skip(offset)
          .take(20)
          .map(
            (w) => QueueWord(
              w.entry.id,
              w.entry.hanzi,
              w.entry.pinyin,
              w.entry.meaning,
            ),
          )
          .toList(),
      words.length > offset + 20,
    );
  }

  @override
  Future<CatalogueWord?> lesson(String id) async =>
      (await starter.load()).where((w) => w.entry.id == id).firstOrNull;
}
