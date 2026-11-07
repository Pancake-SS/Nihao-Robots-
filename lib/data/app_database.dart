import 'package:drift/drift.dart';

part 'app_database.g.dart';

@DataClassName('ProfileRow')
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get level => text()();
  TextColumn get goal => text()();
  IntColumn get dailyMinutes => integer()();
  BoolColumn get showPinyin => boolean()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<String> get customConstraints => [
    'CHECK (length(trim(name)) BETWEEN 1 AND 160)',
    "CHECK (level IN ('beginner', 'basics', 'experienced'))",
    "CHECK (goal IN ('everyday', 'travel', 'reading'))",
    'CHECK (daily_minutes IN (5, 10, 15, 20))',
  ];
}

class AppPreferences extends Table {
  IntColumn get id => integer()();
  IntColumn get selectedProfileId => integer().references(Profiles, #id)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (id = 1)'];
}

class FoundationProgress extends Table {
  IntColumn get profileId => integer().references(Profiles, #id)();
  IntColumn get step => integer()();
  BoolColumn get completed => boolean()();

  @override
  Set<Column> get primaryKey => {profileId};

  @override
  List<String> get customConstraints => ['CHECK (step BETWEEN 0 AND 8)'];
}

class VocabularyProgress extends Table {
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get wordId => text()();
  TextColumn get stage => text()();
  IntColumn get dueAtMs => integer()();
  IntColumn get version => integer()();
  IntColumn get successfulReviews => integer()();

  @override
  Set<Column> get primaryKey => {profileId, wordId};
  @override
  List<String> get customConstraints => [
    'CHECK (length(word_id) BETWEEN 1 AND 100)',
    "CHECK (stage IN ('learning', 'review', 'relearning'))",
    'CHECK (due_at_ms >= 0)',
    'CHECK (version > 0)',
    'CHECK (successful_reviews >= 0)',
  ];
}

class VocabularyAttempts extends Table {
  TextColumn get eventId => text()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get wordId => text()();
  TextColumn get packId => text()();
  IntColumn get contentRevision => integer()();
  IntColumn get versionBefore => integer()();
  BoolColumn get isReview => boolean()();
  TextColumn get answersJson => text()();
  TextColumn get questionsJson => text()();
  BoolColumn get passed => boolean()();
  IntColumn get answeredAtMs => integer()();
  IntColumn get nextDueAtMs => integer()();
  TextColumn get nextStage => text()();

  @override
  Set<Column> get primaryKey => {eventId};
  @override
  List<String> get customConstraints => [
    'CHECK (length(event_id) = 32)',
    'CHECK (content_revision > 0)',
    'CHECK (version_before >= 0)',
    'CHECK (answered_at_ms >= 0)',
    'CHECK (next_due_at_ms >= answered_at_ms)',
    "CHECK (next_stage IN ('learning', 'review', 'relearning'))",
    'UNIQUE (profile_id, word_id, version_before)',
  ];
}

// Shared, versioned learning content is independent of private learner history.
class ContentPacks extends Table {
  TextColumn get id => text()();
  IntColumn get revision => integer()();
  IntColumn get contentSchema => integer()();
  TextColumn get canonicalJson => text()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (revision > 0)',
    'CHECK (content_schema BETWEEN 1 AND 3)',
  ];
}

class ContentWords extends Table {
  TextColumn get id => text()();
  TextColumn get packId => text().references(ContentPacks, #id)();
  IntColumn get position => integer()();
  TextColumn get hanzi => text()();
  TextColumn get pinyin => text()();
  TextColumn get metadataJson => text()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (position >= 0)',
    'UNIQUE (pack_id, position)',
  ];
}

class ContentExamples extends Table {
  TextColumn get wordId =>
      text().references(ContentWords, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get payloadJson => text()();
  @override
  Set<Column> get primaryKey => {wordId, position};
  @override
  List<String> get customConstraints => ['CHECK (position BETWEEN 0 AND 4)'];
}

class ContentExercises extends Table {
  TextColumn get wordId =>
      text().references(ContentWords, #id, onDelete: KeyAction.cascade)();
  TextColumn get questionId => text()();
  IntColumn get position => integer()();
  TextColumn get kind => text()();
  TextColumn get payloadJson => text()();
  @override
  Set<Column> get primaryKey => {wordId, questionId};
  @override
  List<String> get customConstraints => [
    'CHECK (position BETWEEN 0 AND 23)',
    'UNIQUE (word_id, position)',
  ];
}

class CurriculumWords extends Table {
  TextColumn get id => text()();
  TextColumn get packId => text()();
  IntColumn get revision => integer()();
  IntColumn get contentSchema => integer()();
  TextColumn get hanzi => text()();
  TextColumn get pinyin => text()();
  TextColumn get meaning => text()();
  TextColumn get searchText => text()();
  IntColumn get defaultPosition => integer()();
  TextColumn get metadataJson => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class CurriculumSentences extends Table {
  TextColumn get id => text()();
  TextColumn get payloadJson => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class CurriculumExamples extends Table {
  TextColumn get wordId => text().references(CurriculumWords, #id)();
  TextColumn get sentenceId => text().references(CurriculumSentences, #id)();
  IntColumn get position => integer()();
  @override
  Set<Column> get primaryKey => {wordId, position};
  @override
  List<String> get customConstraints => [
    'UNIQUE(word_id, sentence_id)',
    'CHECK(position BETWEEN 0 AND 4)',
  ];
}

@TableIndex.sql(
  'CREATE INDEX curriculum_audio_sentence ON curriculum_audio(sentence_id)',
)
class CurriculumAudio extends Table {
  TextColumn get id => text()();
  TextColumn get sentenceId => text().references(CurriculumSentences, #id)();
  TextColumn get payloadJson => text()();
  BoolColumn get localAvailable => boolean()();
  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex.sql(
  'CREATE INDEX curriculum_question_word ON curriculum_questions(word_id, position)',
)
class CurriculumQuestions extends Table {
  TextColumn get id => text()();
  TextColumn get wordId => text().references(CurriculumWords, #id)();
  IntColumn get position => integer()();
  TextColumn get payloadJson => text()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'UNIQUE(word_id, position)',
    'CHECK(position BETWEEN 0 AND 23)',
  ];
}

class CurriculumInstalls extends Table {
  IntColumn get id => integer()();
  IntColumn get revision => integer()();
  TextColumn get digest => text()();
  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex.sql(
  'CREATE INDEX queue_profile_position ON learning_queue(profile_id, position, word_id)',
)
class LearningQueue extends Table {
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get wordId => text().references(CurriculumWords, #id)();
  IntColumn get position => integer()();
  @override
  Set<Column> get primaryKey => {profileId, wordId};
  @override
  List<String> get customConstraints => ['CHECK(position >= 0)'];
}

@DriftDatabase(
  tables: [
    Profiles,
    AppPreferences,
    FoundationProgress,
    VocabularyProgress,
    VocabularyAttempts,
    ContentPacks,
    ContentWords,
    ContentExamples,
    ContentExercises,
    CurriculumWords,
    CurriculumSentences,
    CurriculumExamples,
    CurriculumAudio,
    CurriculumQuestions,
    CurriculumInstalls,
    LearningQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 1 || from > 4 || to != 5) {
        throw StateError('No migration from schema $from to $to.');
      }
      // Additive migration: existing profiles and selection are never rewritten.
      await transaction(() async {
        if (from < 2) await migrator.createTable(foundationProgress);
        if (from < 3) {
          await migrator.createTable(vocabularyProgress);
          await migrator.createTable(vocabularyAttempts);
        }
        if (from < 4) {
          await migrator.createTable(contentPacks);
          await migrator.createTable(contentWords);
          await migrator.createTable(contentExamples);
          await migrator.createTable(contentExercises);
        }
        for (final table in <TableInfo>[
          curriculumWords,
          curriculumSentences,
          curriculumExamples,
          curriculumAudio,
          curriculumQuestions,
          curriculumInstalls,
          learningQueue,
        ]) {
          await migrator.createTable(table);
        }
        await _curriculumIndexes();
      });
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _curriculumIndexes() async {
    await customStatement(
      'CREATE INDEX curriculum_question_word ON curriculum_questions(word_id, position)',
    );
    await customStatement(
      'CREATE INDEX curriculum_audio_sentence ON curriculum_audio(sentence_id)',
    );
    await customStatement(
      'CREATE INDEX queue_profile_position ON learning_queue(profile_id, position, word_id)',
    );
  }
}
