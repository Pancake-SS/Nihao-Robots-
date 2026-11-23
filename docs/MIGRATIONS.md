# Local database migrations and recovery

The regular Master threshold changed from 25 to 10 correct points on 2026-11-23. This changes eligibility only; saved points and schema version 10 are unchanged. Earlier migration notes below describe the rules in force when those versions were introduced.

## Version 1 through 9 to 10 (2026-11-23)

Schema 10 adds `profile_word_examples`, keyed by profile and bundled word. It stores five learner supplied sentence examples and an optional explanation for an existing word. The lesson reads these rows for the active profile, so bundled words, quiz questions, queue positions and learning progress keep their existing IDs. Reimporting the same Hanzi and Pinyin replaces that profile's example set. Account exports include the new table; older account saves without it still import. `test/custom_word_test.dart` covers a schema 9 upgrade, five example attachment for 扫码, profile isolation and account transfer. Close the app and back up the learner database before launching a schema 10 build.

## Version 1/2/3/4/5/6/7/8 to 9 (2026-11-18)

Schema 9 adds `learning_entries` for Free writing and Notebook. Each entry belongs to a profile and stores its kind, title, writing prompt when applicable, Hanzi/Pinyin/English text and timestamps. Existing profile, vocabulary, grammar, Practice and Master records are preserved. Migration is additive and transactional; from schema 8 it creates only the new table. `test/learning_journal_repository_test.dart` covers a schema-8-shaped file upgrade, profile isolation, reopening, editing and deletion. Back up a closed learner database before opening a schema-9 build. Do not run an older executable against it.

## Version 1/2/3/4/5/6/7 to 8 (2026-11-17)

Schema 8 adds four grammar tables: `grammar_lessons`, `grammar_examples`, `grammar_progress`, and `grammar_installs`. Shared lesson/example rows use stable lesson IDs; completion is stored per profile and can be reversed. No existing profile, vocabulary, Practice, Master, or writing row is rewritten. The migration is additive and transactional. The bundled 428-lesson grammar pack installs transactionally with a revision and digest marker. `test/grammar_repository_test.dart` covers import, pagination, search, profile isolation, reopening, reversing completion and a schema-7-shaped file upgrade that preserves its existing profile. Back up a closed learner database using the procedure below before opening it with schema 8. Older app builds cannot open the upgraded database. The Drift CLI v8 schema export stalled at build hooks on this machine; `drift_schema_v8.json` has not yet been generated.

## Version 1/2/3/4/5/6 to 7 (2026-11-16)

Schema 7 adds `mastered_words` for current Master membership and `master_writings` for saved, ungraded writing. A word is eligible for its Master test at 25 cumulative correct first responses; Instant master bypasses that point threshold but still requires the full test and writing prompt. Returning a word to Learn deletes its current Master membership and learning-progress row while preserving its correctness points, writing, and immutable attempt history. The next initial quiz uses the next historical attempt version, avoiding a version collision. Existing profiles, queue, content and response rows are preserved. The migration is additive and transactional; `test/master_mode_test.dart` covers schema-6 upgrade and retention. Keep `drift_schema_v6.json` as a historical snapshot. The Drift CLI schema-v7 export stalled on this machine; the v7 snapshot remains to be generated separately. Follow the closed-app backup procedure below before opening a real learner database with this version.

Current regular Master tests no longer request or store writing; passing the full quiz records only Master membership. Current Instant master confirms direct promotion with no quiz. The `master_writings` table remains for old learner data and account-save compatibility.

## Version 1/2/3/4/5 to 6 (2026-11-15)

Schema 6 adds `practice_responses`: one immutable first response per profile, word and question visit. Correct rows count as per-word correctness points. The migration preserves every historical profile, word, attempt and queue. For existing attempts it reads the saved answer and question snapshots and backfills first-response rows, so points earned before this update carry forward. New responses are recorded when an answer is checked, including incorrect first tries; correcting a missed question does not add a point. The migration is additive and transactional. A new `drift_schema_v6.json` is kept beside the unchanged older schema snapshots.

Practice no longer waits for a due time or uses a stage to determine availability. Older due/stage columns remain in historical tables for compatibility with saved attempts; new attempts write their answer time as the legacy due value and a neutral `learning` stage. No interval is calculated. The three new session types and relearning search use learned words from the current profile. `test/practice_mode_test.dart` covers migration, point persistence, profile isolation, distinct random words and no repeated endless questions. Follow the closed-app backup procedure below before upgrading a real learner database.

## Version 1/2/3/4 to 5 (2026-11-07)

Schema 5 adds curriculum words, sentences, word/example links, audio, questions, install markers and per-profile learning queues. Existing content tables, profiles, introduction state, attempts, progress and due dates are preserved. Historical snapshots 1-4 are unchanged; `drift_schema_v5.json` is separate.

The bundled curriculum installs transactionally after a digest/integrity check. UPSERT preserves parent identities and saved queue foreign keys; child content updates do not erase learner history. Same-revision digest changes are rejected. `test/curriculum_repository_test.dart` covers a real v4 fixture, old two-question attempts, migration/reopen, queue persistence, a content revision update, closed-file backup restoration, checksum rejection and injected-write rollback/retry. All fixtures use temporary databases.

Before opening this version on real learner data, follow the closed-app backup procedure below. Do not run schema-v4 or older executables against a schema-v5 database.

## Version 1/2/3 → 4 (2026-11-06)

Schema v4 adds `content_packs`, `content_words`, `content_examples` and `content_exercises`. Historical snapshots v1–v3 remain unchanged and v4 is exported separately. The migration creates missing earlier-version tables where needed, then the new content tables. Existing profiles, introduction state, progress, attempts and due dates are preserved.

Validated bundled content is installed in one transaction after opening the database. Stable sense IDs survive pack revisions; a content cascade affects examples/exercises only. Learner history has no cascading content foreign key. Same-version payload changes fail; older bundles cannot silently downgrade installed content. Old two-question greeting attempts remain historical snapshots after the greeting gains eight questions.

`test/content_database_test.dart` verifies a real v3 snapshot upgrade, old attempt/due-date preservation, new content installation, due review, SQLite reopen and closed-file backup restoration. It also checks idempotency, version validation, corruption detection and injected-write rollback. No live learner database was migrated during development. Follow the closed-app backup procedure below before upgrading an existing installation; never run the old app against a schema-v4 database.

## Version 1 → 2 (2026-11-04)

Schema v2 adds `foundation_progress` with one row per profile: profile foreign key, current step (0–8), and completion flag. No profiles, preferences or existing rows are rewritten or removed. Missing rows mean an introduction that has not started. A replay may move the cursor while retaining completion.

The production migration creates only this table. The existing `profiles` and `app_preferences` definitions are unchanged. Unknown version transitions fail explicitly. Generated Dart code and both immutable versioned snapshots are retained in source control; never overwrite a historical snapshot with the current schema.

Writes validate the position, check profile existence, and upsert inside a transaction. Only a final-page acknowledgement can newly complete the introduction. No SQL interpolation, profile reset or delete-on-error path exists. The shared database provider supplies both repositories and closes the connection when its scope is disposed; explicit storage retry creates a fresh connection.

## Before upgrading a real learner installation

1. Fully close the app and verify its process has exited. Locate `ni_hao_robot.sqlite` in the OS application-support directory; preserve the company/product path described in `SETUP.md`.
2. Make a dated backup of the closed database, retaining any `-wal` and `-shm` sidecars if present. Keep that backup separate from the app's active storage. Do not copy a live database piecemeal.
3. Test the upgrade on a copy first. Check profile count, selected ID, names, settings and database foreign keys before resuming normal use.
4. If opening fails, retain the original and backup; retry after resolving the reported environment/storage issue. Never delete the database to make startup pass.

For rollback, close the app, preserve the post-upgrade file separately, and restore a verified pre-upgrade backup with its matching application version. Do not run old code against a newer schema or lower `user_version` manually. A restored backup excludes activity recorded after that backup; retain the newer file for recovery. No real learner database was accessed in development.

## Verification executed

`test/foundation_repository_test.dart` constructs a real v1 SQLite file using the committed v1 snapshot, creates two distinct profiles, selects one, and closes the database before copying its backup. The test opens the current schema (originally v2, now v3), checks preserved profile values/selection, saves distinct introduction states, reopens and verifies them. It separately opens the retained backup and verifies recovered profiles and expected pre-introduction state. Temporary test files only.

## Version 1 or 2 → 3 (2026-11-04)

The additive migration runs in a transaction. A v1 file receives `foundation_progress`, then both vocabulary tables; a v2 file receives only the vocabulary tables. Existing profiles, selection and introduction rows are preserved. Generated code and a new `drift_schema_v3.json` are committed alongside the unchanged historical snapshots. Unsupported transitions fail explicitly.

- `vocabulary_progress`: composite profile/sense key, learning/review/relearning stage, UTC due time, monotonic version and successful delayed-review count.
- `vocabulary_attempts`: unique event ID, profile/sense, pack/revision, previous progress version, initial/review mode, chosen answers, full question/answer-key snapshot, result, attempt time and resulting schedule. A unique profile/sense/previous-version constraint prevents two sessions advancing the same state.

The repository exposes no attempt update/delete operation. It inserts history and upserts progress in one transaction; this is append-only application behavior, not a claim that arbitrary external SQL cannot edit the file. Identical retries return the original receipt, including when content is no longer available. Reusing an event ID with changed answers or identity is rejected. Grading uses canonical content, and due eligibility is checked again at submission. Missing content leaves saved progress intact.

`test/learning_repository_test.dart` migrates a real v2 fixture, verifies profiles/selection/introduction, saves attempts, closes/reopens SQLite, retries a prior event and performs a due review. It also verifies pre-upgrade backup restoration. Tests cover v1→3 through the retained foundation test, failed insert/update rollback, stale sessions, duplicate events, profile isolation, content-revision mismatch, answer validation and injected-clock boundaries. Widget tests cover the whole lesson/quiz/review journey, failure/recovery after restart and a committed save whose acknowledgement is lost.

Before upgrading, extend the checks above to compare attempt counts and due dates if the installation already has learning records. Downgrading to v1/v2 from a v3 file is unsupported; use the matching closed-file backup and keep the newer history for recovery. No live learner database was migrated during development.

Additional checks cover foreign keys, invalid positions, early-completion rejection, transactional rollback on an injected SQLite write failure, retry and monotonic completion. The widget/database restart test advances the introduction through the UI, closes/reopens SQLite, and resumes at the saved page. Full native-process smoke testing remains blocked by the Windows toolchain.

## Curriculum revision 1 to 2 (2026-11-07)

The supplemental examples/TTS change keeps Drift schema 5 and stable word IDs. It updates the seed manifest and bulk lesson revision to 2; old attempts keep their original question snapshots. The existing transactional installer preserves queue foreign keys and history. Direct before/after comparison confirmed all previous sentence records, audio rows and word/example links are retained unchanged. New optional example credit/translation-source/annotation fields use content schema 4. Run the matching new app binary after importing revision 2; an old parser may not understand these additional fields.
