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

@DriftDatabase(tables: [Profiles, AppPreferences])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      // Future schema versions must supply an explicit, tested migration.
      throw StateError('No migration from schema $from to $to.');
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
