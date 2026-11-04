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

@DriftDatabase(
  tables: [
    Profiles,
    AppPreferences,
    FoundationProgress,
    VocabularyProgress,
    VocabularyAttempts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 1 || from > 2 || to != 3) {
        throw StateError('No migration from schema $from to $to.');
      }
      // Additive migration: existing profiles and selection are never rewritten.
      await transaction(() async {
        if (from < 2) await migrator.createTable(foundationProgress);
        await migrator.createTable(vocabularyProgress);
        await migrator.createTable(vocabularyAttempts);
      });
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
