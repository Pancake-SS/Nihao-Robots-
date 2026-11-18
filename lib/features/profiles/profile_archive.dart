import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../grammar/grammar_repository.dart';
import '../vocabulary/curriculum_repository.dart';

/// A profile save contains private progress and learner-created words, never
/// the large bundled curriculum. Import creates a new profile atomically.
class ProfileArchiveRepository {
  const ProfileArchiveRepository(this.database);
  final AppDatabase database;

  static const _profileColumns = <String, List<String>>{
    'foundation_progress': ['profile_id', 'step', 'completed'],
    'vocabulary_progress': [
      'profile_id',
      'word_id',
      'stage',
      'due_at_ms',
      'version',
      'successful_reviews',
    ],
    'vocabulary_attempts': [
      'event_id',
      'profile_id',
      'word_id',
      'pack_id',
      'content_revision',
      'version_before',
      'is_review',
      'answers_json',
      'questions_json',
      'passed',
      'answered_at_ms',
      'next_due_at_ms',
      'next_stage',
    ],
    'practice_responses': [
      'id',
      'profile_id',
      'word_id',
      'question_id',
      'correct',
      'answered_at_ms',
    ],
    'mastered_words': ['profile_id', 'word_id', 'mastered_at_ms'],
    'master_writings': [
      'id',
      'profile_id',
      'word_id',
      'prompt',
      'sentence',
      'written_at_ms',
    ],
    'grammar_progress': ['profile_id', 'lesson_id', 'completed_at_ms'],
    'learning_entries': [
      'profile_id',
      'kind',
      'title',
      'prompt',
      'hanzi',
      'pinyin',
      'english',
      'created_at_ms',
      'updated_at_ms',
    ],
    'learning_queue': ['profile_id', 'word_id', 'position'],
  };
  static const _customColumns = <String, List<String>>{
    'curriculum_words': [
      'id',
      'pack_id',
      'revision',
      'content_schema',
      'hanzi',
      'pinyin',
      'meaning',
      'search_text',
      'default_position',
      'metadata_json',
    ],
    'curriculum_sentences': ['id', 'payload_json'],
    'curriculum_examples': ['word_id', 'sentence_id', 'position'],
    'curriculum_questions': ['id', 'word_id', 'position', 'payload_json'],
  };

  Future<List<Map<String, Object?>>> _read(
    String table,
    List<String> columns,
    String where,
    List<Variable> variables,
  ) async {
    final rows = await database
        .customSelect(
          'SELECT ${columns.join(',')} FROM $table WHERE $where',
          variables: variables,
        )
        .get();
    return [for (final row in rows) Map<String, Object?>.from(row.data)];
  }

  Future<String> exportProfile(int profileId) async {
    final profile = await (database.select(
      database.profiles,
    )..where((row) => row.id.equals(profileId))).getSingleOrNull();
    if (profile == null) throw StateError('This profile no longer exists.');
    final tables = <String, Object?>{};
    for (final entry in _profileColumns.entries) {
      tables[entry.key] = await _read(
        entry.key,
        entry.value,
        'profile_id = ?',
        [Variable.withInt(profileId)],
      );
    }
    final pack = 'custom.p$profileId';
    final custom = <String, Object?>{};
    custom['curriculum_words'] = await _read(
      'curriculum_words',
      _customColumns['curriculum_words']!,
      'pack_id = ?',
      [Variable.withString(pack)],
    );
    custom['curriculum_sentences'] = await _read(
      'curriculum_sentences',
      _customColumns['curriculum_sentences']!,
      'id IN (SELECT e.sentence_id FROM curriculum_examples e JOIN curriculum_words w ON w.id=e.word_id WHERE w.pack_id=?)',
      [Variable.withString(pack)],
    );
    custom['curriculum_examples'] = await _read(
      'curriculum_examples',
      _customColumns['curriculum_examples']!,
      'word_id IN (SELECT id FROM curriculum_words WHERE pack_id=?)',
      [Variable.withString(pack)],
    );
    custom['curriculum_questions'] = await _read(
      'curriculum_questions',
      _customColumns['curriculum_questions']!,
      'word_id IN (SELECT id FROM curriculum_words WHERE pack_id=?)',
      [Variable.withString(pack)],
    );
    final payload = <String, Object?>{
      'profile': {
        'id': profile.id,
        'name': profile.name,
        'level': profile.level,
        'goal': profile.goal,
        'dailyMinutes': profile.dailyMinutes,
        'showPinyin': profile.showPinyin,
        'createdAt': profile.createdAt.toUtc().toIso8601String(),
      },
      'tables': tables,
      'custom': custom,
    };
    return const JsonEncoder.withIndent('  ').convert({
      'format': 'nihao-profile-save',
      'version': 1,
      'checksum': sha256.convert(utf8.encode(jsonEncode(payload))).toString(),
      'payload': payload,
    });
  }

  static String _newId() {
    final random = Random.secure();
    return List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  Future<int> importProfile(String source) async {
    if (utf8.encode(source).length > 50 * 1024 * 1024) {
      throw const FormatException('This account save is too large.');
    }
    final archive = jsonDecode(source);
    if (archive is! Map<String, dynamic> ||
        archive['format'] != 'nihao-profile-save' ||
        archive['version'] != 1 ||
        archive['payload'] is! Map<String, dynamic>) {
      throw const FormatException(
        'This is not a supported Ni Hao Robot account save.',
      );
    }
    final payload = archive['payload'] as Map<String, dynamic>;
    if (sha256.convert(utf8.encode(jsonEncode(payload))).toString() !=
        archive['checksum']) {
      throw const FormatException(
        'The account save is incomplete or has changed.',
      );
    }
    final profile = payload['profile'];
    final tables = payload['tables'];
    final custom = payload['custom'];
    if (profile is! Map<String, dynamic> ||
        tables is! Map<String, dynamic> ||
        custom is! Map<String, dynamic> ||
        profile['id'] is! int ||
        profile['name'] is! String ||
        profile['level'] is! String ||
        profile['goal'] is! String ||
        profile['dailyMinutes'] is! int ||
        profile['showPinyin'] is! bool ||
        profile['createdAt'] is! String) {
      throw const FormatException('Account settings are missing.');
    }
    final oldId = profile['id'] as int;
    final name = (profile['name'] as String).trim();
    if (oldId < 1 || name.isEmpty || name.length > 160)
      throw const FormatException('Invalid account settings.');
    for (final entry in {..._profileColumns, ..._customColumns}.entries) {
      final group = _profileColumns.containsKey(entry.key) ? tables : custom;
      final rows = group[entry.key];
      if (rows is! List ||
          rows.any(
            (row) =>
                row is! Map<String, dynamic> ||
                row.keys.toSet().difference(entry.value.toSet()).isNotEmpty ||
                entry.value.toSet().difference(row.keys.toSet()).isNotEmpty,
          )) {
        throw FormatException('Invalid ${entry.key} in account save.');
      }
    }
    // Install shared packs before the transaction, so foreign keys can check
    // queue words and grammar lesson IDs without partly importing a profile.
    return database.transaction(() async {
      final existing = await (database.select(
        database.profiles,
      )..where((row) => row.name.equals(name))).get();
      final newName = existing.isEmpty
          ? name
          : '${name.substring(0, min(name.length, 140))} (imported ${_newId().substring(0, 6)})';
      final newProfileId = await database
          .into(database.profiles)
          .insert(
            ProfilesCompanion.insert(
              name: newName,
              level: profile['level'] as String,
              goal: profile['goal'] as String,
              dailyMinutes: profile['dailyMinutes'] as int,
              showPinyin: profile['showPinyin'] as bool,
              createdAt: DateTime.parse(profile['createdAt'] as String),
            ),
          );
      final oldPrefix = 'custom.p$oldId';
      final newPrefix = 'custom.p$newProfileId';
      final attemptIds = <String, String>{};
      Object? convert(Object? value, {String? key}) {
        if (key == 'profile_id' || key == 'ownerProfileId') return newProfileId;
        if (value is String) {
          if (key == 'event_id') return attemptIds.putIfAbsent(value, _newId);
          if (key == 'answers_json' ||
              key == 'questions_json' ||
              key == 'metadata_json' ||
              key == 'payload_json') {
            final decoded = jsonDecode(value);
            return jsonEncode(convert(decoded));
          }
          if (key == 'id' && RegExp(r'^[a-f0-9]{32}$').hasMatch(value))
            return _newId();
          if (key == 'id' && value.contains('.')) {
            final prefix = value.split('.').first;
            if (attemptIds.containsKey(prefix))
              return value.replaceFirst(prefix, attemptIds[prefix]!);
          }
          return value.replaceAll(oldPrefix, newPrefix);
        }
        if (value is List) return [for (final item in value) convert(item)];
        if (value is Map)
          return {
            for (final item in value.entries)
              (item.key is String
                  ? (item.key as String).replaceAll(oldPrefix, newPrefix)
                  : item.key): convert(
                item.value,
                key: item.key.toString(),
              ),
          };
        return value;
      }

      Future<void> insertRows(
        String table,
        List<String> columns,
        List rows,
      ) async {
        final marks = List.filled(columns.length, '?').join(',');
        for (final raw in rows) {
          final row = raw as Map<String, dynamic>;
          await database.customStatement(
            'INSERT INTO $table (${columns.join(',')}) VALUES ($marks)',
            [
              for (final column in columns)
                if (column == 'id' &&
                    (table == 'practice_responses' ||
                        table == 'master_writings'))
                  _newId()
                else
                  convert(row[column], key: column),
            ],
          );
        }
      }

      for (final entry in _customColumns.entries) {
        await insertRows(entry.key, entry.value, custom[entry.key] as List);
      }
      for (final entry in _profileColumns.entries) {
        await insertRows(entry.key, entry.value, tables[entry.key] as List);
      }
      return newProfileId;
    });
  }
}

final profileArchiveRepositoryProvider = Provider<ProfileArchiveRepository>(
  (ref) => ProfileArchiveRepository(ref.watch(appDatabaseProvider)),
);

final profileArchiveReadyProvider = FutureProvider<void>((ref) async {
  await ref.read(curriculumRepositoryProvider).ready();
  await ref.read(grammarRepositoryProvider).ready();
});
