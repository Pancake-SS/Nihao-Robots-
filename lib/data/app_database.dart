import 'dart:convert';

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

/// One immutable first response per quiz visit. Correct responses are the
/// learner's per-word correctness points, independent of review timing.
class PracticeResponses extends Table {
  TextColumn get id => text()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get wordId => text()();
  TextColumn get questionId => text()();
  BoolColumn get correct => boolean()();
  IntColumn get answeredAtMs => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

/// Current mastery is separate from cumulative correctness history.
class MasteredWords extends Table {
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get wordId => text()();
  IntColumn get masteredAtMs => integer()();
  @override
  Set<Column> get primaryKey => {profileId, wordId};
}

/// Writing is retained if a mastered word later returns to Learn.
class MasterWritings extends Table {
  TextColumn get id => text()();
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get wordId => text()();
  TextColumn get prompt => text()();
  TextColumn get sentence => text()();
  IntColumn get writtenAtMs => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

/// Shared grammar syllabus; private completion lives in GrammarProgress.
@DataClassName('GrammarLessonRow')
class GrammarLessons extends Table {
  TextColumn get id => text()();
  IntColumn get position => integer()();
  IntColumn get level => integer()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  TextColumn get pattern => text()();
  TextColumn get explanation => text()();
  TextColumn get allsetId => text().nullable()();
  TextColumn get allsetTitle => text().nullable()();
  TextColumn get allsetNote => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (position >= 0)',
    'CHECK (level BETWEEN 1 AND 9)',
  ];
}

class GrammarExamples extends Table {
  TextColumn get lessonId => text().references(GrammarLessons, #id)();
  IntColumn get position => integer()();
  TextColumn get chinese => text()();
  TextColumn get pinyin => text()();
  TextColumn get english => text()();
  TextColumn get source => text()();
  @override
  Set<Column> get primaryKey => {lessonId, position};
  @override
  List<String> get customConstraints => [
    'CHECK (position BETWEEN 0 AND 4)',
    "CHECK (source IN ('gushi', 'allset'))",
  ];
}

class GrammarProgress extends Table {
  IntColumn get profileId => integer().references(Profiles, #id)();
  TextColumn get lessonId => text().references(GrammarLessons, #id)();
  IntColumn get completedAtMs => integer()();
  @override
  Set<Column> get primaryKey => {profileId, lessonId};
}

class GrammarInstalls extends Table {
  IntColumn get id => integer()();
  IntColumn get revision => integer()();
  TextColumn get digest => text()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (id = 1)',
    'CHECK (revision > 0)',
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
    PracticeResponses,
    MasteredWords,
    MasterWritings,
    GrammarLessons,
    GrammarExamples,
    GrammarProgress,
    GrammarInstalls,
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
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 1 || from > 7 || to != 8) {
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
        if (from < 5) {
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
        }
        if (from < 6) {
          await migrator.createTable(practiceResponses);
        }
        if (from >= 3 && from < 6) {
          final attempts = await customSelect(
            'SELECT event_id, profile_id, word_id, answers_json, questions_json, answered_at_ms FROM vocabulary_attempts',
          ).get();
          for (final attempt in attempts) {
            final answers = jsonDecode(
              attempt.read<String>('answers_json'),
            ) as Map<String, dynamic>;
            final questions = jsonDecode(
              attempt.read<String>('questions_json'),
            ) as List<dynamic>;
            for (final raw in questions) {
              final question = raw as Map<String, dynamic>;
              final id = question['id'] as String;
              final answer = answers[id] as String?;
              final correctId = question['correctOptionId'] as String;
              final typed = question['kind'] == 'typed_hanzi';
              final options = question['options'] as Map<String, dynamic>;
              final correct = typed
                  ? answer?.trim() == options[correctId]
                  : answer == correctId;
              await customStatement(
                'INSERT OR IGNORE INTO practice_responses '
                '(id, profile_id, word_id, question_id, correct, answered_at_ms) '
                'VALUES (?, ?, ?, ?, ?, ?)',
                [
                  '${attempt.read<String>('event_id')}.$id',
                  attempt.read<int>('profile_id'),
                  attempt.read<String>('word_id'),
                  id,
                  correct ? 1 : 0,
                  attempt.read<int>('answered_at_ms'),
                ],
              );
            }
          }
        }
        if (from < 7) {
          await migrator.createTable(masteredWords);
          await migrator.createTable(masterWritings);
        }
        await migrator.createTable(grammarLessons);
        await migrator.createTable(grammarExamples);
        await migrator.createTable(grammarProgress);
        await migrator.createTable(grammarInstalls);
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
