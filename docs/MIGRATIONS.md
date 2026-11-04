# Local database migrations and recovery

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
