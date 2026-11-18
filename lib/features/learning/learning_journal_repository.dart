import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';

enum LearningEntryKind { writing, note }

class LearningEntryDraft {
  const LearningEntryDraft({
    required this.kind,
    required this.title,
    required this.hanzi,
    required this.pinyin,
    required this.english,
    this.prompt = '',
  });

  final LearningEntryKind kind;
  final String title, prompt, hanzi, pinyin, english;

  LearningEntryDraft normalized() {
    final result = LearningEntryDraft(
      kind: kind,
      title: title.trim(),
      prompt: prompt.trim(),
      hanzi: hanzi.trim(),
      pinyin: pinyin.trim(),
      english: english.trim(),
    );
    if (result.title.isEmpty || result.title.length > 120) {
      throw ArgumentError('Add a title of at most 120 characters.');
    }
    if (result.prompt.length > 500 ||
        result.hanzi.length > 10000 ||
        result.pinyin.length > 10000 ||
        result.english.length > 10000) {
      throw ArgumentError('This entry is too long.');
    }
    if (result.kind == LearningEntryKind.writing && result.prompt.isEmpty) {
      throw ArgumentError('Choose a writing topic.');
    }
    if (result.kind == LearningEntryKind.note && result.prompt.isNotEmpty) {
      throw ArgumentError('Notebook pages do not have a writing prompt.');
    }
    if (result.hanzi.isEmpty &&
        result.pinyin.isEmpty &&
        result.english.isEmpty) {
      throw ArgumentError('Write something before saving.');
    }
    return result;
  }
}

class LearningJournalRepository {
  LearningJournalRepository(this.database);
  final AppDatabase database;

  Future<List<LearningEntry>> list(
    int profileId,
    LearningEntryKind kind, {
    int page = 0,
    String search = '',
  }) async {
    if (page < 0 || search.length > 100) {
      throw ArgumentError('Invalid page or search.');
    }
    final rows = await database
        .customSelect(
          'SELECT * FROM learning_entries WHERE $_filter '
          'ORDER BY updated_at_ms DESC, id DESC LIMIT 20 OFFSET ?',
          variables: [
            ..._variables(profileId, kind, search),
            Variable.withInt(page * 20),
          ],
          readsFrom: {database.learningEntries},
        )
        .get();
    return [for (final row in rows) database.learningEntries.map(row.data)];
  }

  static const _filter =
      "profile_id = ? AND kind = ? AND "
      "instr(lower(title || ' ' || hanzi || ' ' || pinyin || ' ' || english), ?) > 0";

  List<Variable> _variables(
    int profileId,
    LearningEntryKind kind,
    String search,
  ) => [
    Variable.withInt(profileId),
    Variable.withString(kind.name),
    Variable.withString(search.trim().toLowerCase()),
  ];

  Future<int> count(
    int profileId,
    LearningEntryKind kind, {
    String search = '',
  }) async {
    if (search.length > 100) throw ArgumentError.value(search, 'search');
    final row = await database
        .customSelect(
          'SELECT COUNT(*) AS total FROM learning_entries WHERE $_filter',
          variables: _variables(profileId, kind, search),
        )
        .getSingle();
    return row.read<int>('total');
  }

  Future<LearningEntry?> get(int profileId, int id) =>
      (database.select(database.learningEntries)
            ..where((e) => e.profileId.equals(profileId) & e.id.equals(id)))
          .getSingleOrNull();

  Future<int> save(int profileId, LearningEntryDraft input, {int? id}) async {
    final draft = input.normalized();
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    if (id == null) {
      return database
          .into(database.learningEntries)
          .insert(
            LearningEntriesCompanion.insert(
              profileId: profileId,
              kind: draft.kind.name,
              title: draft.title,
              prompt: draft.prompt,
              hanzi: draft.hanzi,
              pinyin: draft.pinyin,
              english: draft.english,
              createdAtMs: now,
              updatedAtMs: now,
            ),
          );
    }
    final existing = await get(profileId, id);
    if (existing == null || existing.kind != draft.kind.name) {
      throw StateError('This entry is no longer available.');
    }
    final changed =
        await (database.update(
          database.learningEntries,
        )..where((e) => e.profileId.equals(profileId) & e.id.equals(id))).write(
          LearningEntriesCompanion(
            title: Value(draft.title),
            prompt: Value(draft.prompt),
            hanzi: Value(draft.hanzi),
            pinyin: Value(draft.pinyin),
            english: Value(draft.english),
            updatedAtMs: Value(now),
          ),
        );
    if (changed != 1) throw StateError('This entry is no longer available.');
    return id;
  }

  Future<bool> delete(int profileId, int id) async =>
      await (database.delete(
        database.learningEntries,
      )..where((e) => e.profileId.equals(profileId) & e.id.equals(id))).go() ==
      1;
}

final learningJournalRepositoryProvider = Provider<LearningJournalRepository>(
  (ref) => LearningJournalRepository(ref.watch(appDatabaseProvider)),
);
