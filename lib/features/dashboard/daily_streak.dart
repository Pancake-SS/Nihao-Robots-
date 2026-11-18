import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';

class DailyActivity {
  const DailyActivity({
    this.newWords = 0,
    this.quizWords = 0,
    this.masteredWords = 0,
    this.writings = 0,
  });

  final int newWords, quizWords, masteredWords, writings;
  bool get complete =>
      newWords >= 10 && quizWords >= 20 && masteredWords >= 10 && writings >= 1;
}

class DailyStreak {
  const DailyStreak(this.days, this.count, this.today);
  final Map<String, DailyActivity> days;
  final int count;
  final DailyActivity today;
}

class DailyStreakRepository {
  const DailyStreakRepository(this.database);
  final AppDatabase database;

  static String dayKey(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  Future<DailyStreak> load(int profileId, {DateTime? now}) async {
    final current = now ?? DateTime.now();
    final counts = <String, List<int>>{};
    Future<void> add(String sql, int slot) async {
      final rows = await database
          .customSelect(sql, variables: [Variable.withInt(profileId)])
          .get();
      for (final row in rows) {
        final day = row.read<String>('day');
        final values = counts.putIfAbsent(day, () => [0, 0, 0, 0]);
        values[slot] = row.read<int>('total');
      }
    }

    // Each distinct word contributes once per local calendar day. First lesson
    // quizzes and Master quizzes both contribute to the quiz target.
    await add(
      "SELECT strftime('%Y-%m-%d', answered_at_ms / 1000, 'unixepoch', 'localtime') AS day, COUNT(DISTINCT word_id) AS total FROM vocabulary_attempts WHERE profile_id = ? AND is_review = 0 AND passed = 1 GROUP BY day",
      0,
    );
    await add(
      "SELECT strftime('%Y-%m-%d', answered_at_ms / 1000, 'unixepoch', 'localtime') AS day, COUNT(DISTINCT word_id) AS total FROM practice_responses WHERE profile_id = ? GROUP BY day",
      1,
    );
    await add(
      "SELECT strftime('%Y-%m-%d', p.answered_at_ms / 1000, 'unixepoch', 'localtime') AS day, COUNT(DISTINCT p.word_id) AS total FROM practice_responses p WHERE p.profile_id = ? AND EXISTS (SELECT 1 FROM master_writings m WHERE m.profile_id = p.profile_id AND m.word_id = p.word_id AND m.written_at_ms <= p.answered_at_ms) GROUP BY day",
      2,
    );
    await add(
      "SELECT strftime('%Y-%m-%d', created_at_ms / 1000, 'unixepoch', 'localtime') AS day, COUNT(*) AS total FROM learning_entries WHERE profile_id = ? AND kind = 'writing' GROUP BY day",
      3,
    );
    final days = {
      for (final entry in counts.entries)
        entry.key: DailyActivity(
          newWords: entry.value[0],
          quizWords: entry.value[1],
          masteredWords: entry.value[2],
          writings: entry.value[3],
        ),
    };
    var cursor = DateTime(current.year, current.month, current.day);
    if (days[dayKey(cursor)]?.complete != true) {
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    var streak = 0;
    while (days[dayKey(cursor)]?.complete == true) {
      streak++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    return DailyStreak(
      days,
      streak,
      days[dayKey(current)] ?? const DailyActivity(),
    );
  }
}

final dailyStreakRepositoryProvider = Provider<DailyStreakRepository>(
  (ref) => DailyStreakRepository(ref.watch(appDatabaseProvider)),
);

final dailyStreakProvider = FutureProvider.family<DailyStreak, int>(
  (ref, profileId) => ref.watch(dailyStreakRepositoryProvider).load(profileId),
  retry: (_, _) => null,
);
