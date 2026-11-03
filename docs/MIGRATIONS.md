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

For rollback, close the app, preserve the post-upgrade file separately, and restore a verified pre-upgrade backup with the matching schema-v1 application. Do not run old code against a newer schema or lower `user_version` manually. A restored pre-upgrade backup will not include introduction activity recorded after that backup; retain the newer file for recovery. No real learner database was accessed in development.

## Verification executed

`test/foundation_repository_test.dart` constructs a real v1 SQLite file using the committed v1 snapshot, creates two distinct profiles, selects one, and closes the database before copying its backup. The test opens v2, checks preserved profile values/selection, saves distinct introduction states, reopens and verifies them. It separately opens the retained backup and verifies recovered profiles and expected pre-introduction state. Temporary test files only.

Additional checks cover foreign keys, invalid positions, early-completion rejection, transactional rollback on an injected SQLite write failure, retry and monotonic completion. The widget/database restart test advances the introduction through the UI, closes/reopens SQLite, and resumes at the saved page. Full native-process smoke testing remains blocked by the Windows toolchain.
