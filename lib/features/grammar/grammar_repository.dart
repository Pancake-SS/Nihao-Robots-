import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';

class GrammarExample {
  const GrammarExample(this.chinese, this.pinyin, this.english, this.source);
  final String chinese, pinyin, english, source;
}

class GrammarLesson {
  const GrammarLesson({
    required this.id,
    required this.position,
    required this.level,
    required this.title,
    required this.category,
    required this.pattern,
    required this.explanation,
    required this.examples,
    required this.completed,
    this.allsetId,
    this.allsetTitle,
    this.allsetNote,
  });
  final String id, title, category, pattern, explanation;
  final int position, level;
  final List<GrammarExample> examples;
  final bool completed;
  final String? allsetId, allsetTitle, allsetNote;
  String? get allsetUrl => allsetId == null
      ? null
      : 'https://resources.allsetlearning.com/chinese/grammar/$allsetId';
}

class GrammarPage {
  const GrammarPage(this.lessons, this.total);
  final List<GrammarLesson> lessons;
  final int total;
}

class GrammarCounts {
  const GrammarCounts(this.pending, this.completed);
  final int pending, completed;
}

class GrammarRepository {
  GrammarRepository(this.database, {AssetBundle? bundle})
    : bundle = bundle ?? rootBundle;
  final AppDatabase database;
  final AssetBundle bundle;
  Future<void>? _ready;

  Future<void> ready() =>
      _ready ??= _install().catchError((Object error, StackTrace stack) {
        _ready = null;
        Error.throwWithStackTrace(error, stack);
      });

  Future<void> _install() async {
    final raw = await bundle.loadString('assets/content/grammar_v1.json');
    final digest = sha256.convert(utf8.encode(raw)).toString();
    final pack = jsonDecode(raw) as Map<String, dynamic>;
    final revision = pack['revision'];
    final rows = pack['lessons'];
    if (revision is! int ||
        revision < 1 ||
        rows is! List ||
        rows.length != 428) {
      throw const FormatException('Grammar pack is incomplete.');
    }
    final parsed = <Map<String, dynamic>>[];
    final ids = <String>{}, positions = <int>{};
    for (final rawRow in rows) {
      if (rawRow is! Map<String, dynamic>) {
        throw const FormatException('Invalid grammar lesson.');
      }
      final id = rawRow['id'], position = rawRow['position'];
      final level = rawRow['level'], examples = rawRow['examples'];
      if (id is! String ||
          !RegExp(r'^hsk3\.grammar\.[a-f0-9]{16}$').hasMatch(id) ||
          !ids.add(id) ||
          position is! int ||
          position < 0 ||
          !positions.add(position) ||
          level is! int ||
          level < 1 ||
          level > 9 ||
          examples is! List ||
          examples.isEmpty ||
          examples.length > 5 ||
          [
            rawRow['title'],
            rawRow['category'],
            rawRow['explanation'],
          ].any((value) => value is! String || value.trim().isEmpty) ||
          rawRow['pattern'] is! String) {
        throw const FormatException('Invalid grammar lesson fields.');
      }
      final allset = rawRow['allset'];
      if (allset != null &&
          (allset is! Map<String, dynamic> ||
              allset['id'] is! String ||
              !RegExp(r'^ASG[A-Z0-9]{5}$').hasMatch(allset['id'] as String) ||
              allset['title'] is! String ||
              allset['note'] is! String)) {
        throw const FormatException('Invalid grammar source link.');
      }
      for (final example in examples) {
        if (example is! Map<String, dynamic> ||
            [
              example['chinese'],
              example['pinyin'],
              example['english'],
              example['source'],
            ].any((value) => value is! String) ||
            (example['chinese'] as String).trim().isEmpty ||
            (example['english'] as String).trim().isEmpty ||
            !['gushi', 'allset'].contains(example['source']) ||
            (example['source'] == 'allset' && allset == null)) {
          throw const FormatException('Invalid grammar example.');
        }
      }
      parsed.add(rawRow);
    }
    if (positions.length != rows.length ||
        positions.reduce((a, b) => a < b ? a : b) != 0 ||
        positions.reduce((a, b) => a > b ? a : b) != rows.length - 1) {
      throw const FormatException('Grammar positions are incomplete.');
    }
    await database.transaction(() async {
      final installed = await database
          .select(database.grammarInstalls)
          .getSingleOrNull();
      if (installed != null) {
        if (installed.revision > revision) return;
        if (installed.revision == revision) {
          if (installed.digest != digest) {
            throw const FormatException(
              'Grammar pack changed without revision.',
            );
          }
          return;
        }
      }
      for (final row in parsed) {
        final allset = row['allset'] as Map<String, dynamic>?;
        await database
            .into(database.grammarLessons)
            .insertOnConflictUpdate(
              GrammarLessonsCompanion.insert(
                id: row['id'] as String,
                position: row['position'] as int,
                level: row['level'] as int,
                title: row['title'] as String,
                category: row['category'] as String,
                pattern: row['pattern'] as String,
                explanation: row['explanation'] as String,
                allsetId: Value(allset?['id'] as String?),
                allsetTitle: Value(allset?['title'] as String?),
                allsetNote: Value(allset?['note'] as String?),
              ),
            );
        await (database.delete(
          database.grammarExamples,
        )..where((e) => e.lessonId.equals(row['id'] as String))).go();
        final examples = row['examples'] as List;
        for (var i = 0; i < examples.length; i++) {
          final example = examples[i] as Map<String, dynamic>;
          await database
              .into(database.grammarExamples)
              .insert(
                GrammarExamplesCompanion.insert(
                  lessonId: row['id'] as String,
                  position: i,
                  chinese: example['chinese'] as String,
                  pinyin: example['pinyin'] as String,
                  english: example['english'] as String,
                  source: example['source'] as String,
                ),
              );
        }
      }
      await database
          .into(database.grammarInstalls)
          .insertOnConflictUpdate(
            GrammarInstallsCompanion.insert(
              id: const Value(1),
              revision: revision,
              digest: digest,
            ),
          );
    });
  }

  GrammarLesson _lesson(
    GrammarLessonRow row,
    bool completed, [
    List<GrammarExample> examples = const [],
  ]) => GrammarLesson(
    id: row.id,
    position: row.position,
    level: row.level,
    title: row.title,
    category: row.category,
    pattern: row.pattern,
    explanation: row.explanation,
    examples: examples,
    completed: completed,
    allsetId: row.allsetId,
    allsetTitle: row.allsetTitle,
    allsetNote: row.allsetNote,
  );

  Future<GrammarCounts> counts(int profileId) async {
    await ready();
    final rows = await database
        .customSelect(
          'SELECT (SELECT COUNT(*) FROM grammar_lessons) AS total, '
          '(SELECT COUNT(*) FROM grammar_progress WHERE profile_id = ?) AS completed',
          variables: [Variable.withInt(profileId)],
        )
        .getSingle();
    final completed = rows.read<int>('completed');
    return GrammarCounts(rows.read<int>('total') - completed, completed);
  }

  Future<List<String>> categories() async {
    await ready();
    final rows = await database
        .customSelect(
          'SELECT DISTINCT category FROM grammar_lessons ORDER BY category',
        )
        .get();
    return [for (final row in rows) row.read<String>('category')];
  }

  Future<GrammarPage> page(
    int profileId, {
    required bool completed,
    int page = 0,
    String search = '',
    int? level,
    String? category,
  }) async {
    await ready();
    if (page < 0 || search.length > 100)
      throw ArgumentError('Invalid page or search.');
    final conditions = <String>[
      completed ? 'p.lesson_id IS NOT NULL' : 'p.lesson_id IS NULL',
      "instr(lower(l.title || ' ' || l.category || ' ' || l.pattern || ' ' || l.explanation), ?) > 0",
    ];
    final vars = <Variable>[
      Variable.withInt(profileId),
      Variable.withString(search.trim().toLowerCase()),
    ];
    if (level != null) {
      conditions.add('l.level = ?');
      vars.add(Variable.withInt(level));
    }
    if (category != null) {
      conditions.add('l.category = ?');
      vars.add(Variable.withString(category));
    }
    final from =
        'FROM grammar_lessons l LEFT JOIN grammar_progress p '
        'ON p.lesson_id = l.id AND p.profile_id = ? WHERE ${conditions.join(' AND ')}';
    final count = await database
        .customSelect('SELECT COUNT(*) AS total $from', variables: vars)
        .getSingle();
    final rows = await database
        .customSelect(
          'SELECT l.* $from ORDER BY l.position LIMIT 20 OFFSET ?',
          variables: [...vars, Variable.withInt(page * 20)],
          readsFrom: {database.grammarLessons, database.grammarProgress},
        )
        .get();
    return GrammarPage([
      for (final row in rows)
        _lesson(database.grammarLessons.map(row.data), completed),
    ], count.read<int>('total'));
  }

  Future<GrammarLesson?> detail(int profileId, String id) async {
    await ready();
    final row = await (database.select(
      database.grammarLessons,
    )..where((l) => l.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final completed =
        await (database.select(database.grammarProgress)..where(
              (p) => p.profileId.equals(profileId) & p.lessonId.equals(id),
            ))
            .getSingleOrNull();
    final examples =
        await (database.select(database.grammarExamples)
              ..where((e) => e.lessonId.equals(id))
              ..orderBy([(e) => OrderingTerm.asc(e.position)]))
            .get();
    return _lesson(row, completed != null, [
      for (final example in examples)
        GrammarExample(
          example.chinese,
          example.pinyin,
          example.english,
          example.source,
        ),
    ]);
  }

  Future<void> setCompleted(int profileId, String id, bool completed) async {
    await ready();
    await database.transaction(() async {
      final profile = await (database.select(
        database.profiles,
      )..where((p) => p.id.equals(profileId))).getSingleOrNull();
      final lesson = await (database.select(
        database.grammarLessons,
      )..where((l) => l.id.equals(id))).getSingleOrNull();
      if (profile == null || lesson == null) {
        throw StateError('This grammar lesson is unavailable.');
      }
      if (completed) {
        await database
            .into(database.grammarProgress)
            .insert(
              GrammarProgressCompanion.insert(
                profileId: profileId,
                lessonId: id,
                completedAtMs: DateTime.now().toUtc().millisecondsSinceEpoch,
              ),
              mode: InsertMode.insertOrIgnore,
            );
      } else {
        await (database.delete(database.grammarProgress)..where(
              (p) => p.profileId.equals(profileId) & p.lessonId.equals(id),
            ))
            .go();
      }
    });
  }
}

final grammarRepositoryProvider = Provider<GrammarRepository>(
  (ref) => GrammarRepository(ref.watch(appDatabaseProvider)),
);

final grammarCountsProvider = FutureProvider.family<GrammarCounts, int>(
  (ref, id) => ref.watch(grammarRepositoryProvider).counts(id),
  retry: (_, _) => null,
);
