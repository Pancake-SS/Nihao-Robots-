import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/features/dashboard/daily_streak.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';

void main() {
  test('old Master writing still credits historical review days', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Legacy'))).selected!.id;
    final day = DateTime(2026, 11, 18, 12).millisecondsSinceEpoch;
    await db.customStatement(
      'INSERT INTO master_writings (id,profile_id,word_id,prompt,sentence,written_at_ms) VALUES (?,?,?,?,?,?)',
      ['old-master', profile, 'old-word', 'Old prompt', '你好。', day],
    );
    await db.customStatement(
      'INSERT INTO practice_responses (id,profile_id,word_id,question_id,correct,answered_at_ms) VALUES (?,?,?,?,?,?)',
      ['old-review', profile, 'old-word', 'q1', 1, day + 1],
    );
    final streak = await DailyStreakRepository(db)
        .load(profile, now: DateTime(2026, 11, 18, 15));
    expect(streak.today.masteredWords, 1);
  });

  test('daily goals use distinct words, include quizzes, and survive midnight', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final profile = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Mei'))).selected!.id;
    final now = DateTime(2026, 11, 19, 15);
    final previous = DateTime(2026, 11, 18, 12).millisecondsSinceEpoch;
    final today = DateTime(2026, 11, 19, 12).millisecondsSinceEpoch;

    Future<void> addDay(int stamp, int day, {required bool complete}) async {
      for (var i = 0; i < 20; i++) {
        final wordId = 'day$day-word$i';
        await db.customStatement(
          'INSERT INTO practice_responses (id,profile_id,word_id,question_id,correct,answered_at_ms) VALUES (?,?,?,?,?,?)',
          ['quiz-$day-$i', profile, wordId, 'q1', 1, stamp],
        );
        if (i < 10) {
          await db.customStatement(
            'INSERT INTO vocabulary_attempts (event_id,profile_id,word_id,pack_id,content_revision,version_before,is_review,answers_json,questions_json,passed,answered_at_ms,next_due_at_ms,next_stage) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
            [
              '${day.toString().padLeft(2, '0')}${i.toString().padLeft(2, '0')}'
                  .padRight(32, '0'),
              profile,
              wordId,
              'test',
              1,
              0,
              0,
              '[]',
              '[]',
              1,
              stamp,
              stamp,
              'learning',
            ],
          );
          if (complete || i < 9) {
            await db.customStatement(
              'INSERT INTO mastered_words (profile_id,word_id,mastered_at_ms) VALUES (?,?,?)',
              [profile, wordId, stamp],
            );
          }
        }
      }
      await db.customStatement(
        'INSERT INTO learning_entries (profile_id,kind,title,prompt,hanzi,pinyin,english,created_at_ms,updated_at_ms) VALUES (?,?,?,?,?,?,?,?,?)',
        [profile, 'writing', 'A thought', 'Write', '你好。', '', '', stamp, stamp],
      );
    }

    await addDay(previous, 18, complete: true);
    await addDay(today, 19, complete: false);
    final repo = DailyStreakRepository(db);
    var streak = await repo.load(profile, now: now);
    expect(
      streak.count,
      1,
    ); // Yesterday stays active while today is unfinished.
    expect(streak.today.newWords, 10);
    expect(streak.today.quizWords, 20);
    expect(streak.today.masteredWords, 9);
    expect(streak.today.writings, 1);

    await db.customStatement(
      'INSERT INTO mastered_words (profile_id,word_id,mastered_at_ms) VALUES (?,?,?)',
      [profile, 'day19-word9', today + 1],
    );
    expect((await repo.load(profile, now: now)).today.masteredWords, 9);
    await db.customStatement(
      'INSERT INTO practice_responses (id,profile_id,word_id,question_id,correct,answered_at_ms) VALUES (?,?,?,?,?,?)',
      ['master-review', profile, 'day19-word9', 'q2', 1, today + 2],
    );
    streak = await repo.load(profile, now: now);
    expect(streak.count, 2);
    expect(streak.today.complete, isTrue);
    final other = (await SqliteProfileRepository(
      db,
    ).create(const ProfileDraft(name: 'Other'))).selected!.id;
    expect((await repo.load(other, now: now)).count, 0);
  });
}
