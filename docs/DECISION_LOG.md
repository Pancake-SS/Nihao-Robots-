# Ni Hao Robot! — Decision log

## 2026-11-03: source reconciliation and bootstrap scope

Authority: latest user prompt, then Master Plan, Coding Standards, actual PPT notes/comments, then slide artwork.

| Conflict / decision | Resolution and consequence |
|---|---|
| Slide 1 login/signup; Master Plan avoids mandatory accounts | Multiple local profiles with isolated progress. No password form or example credentials. Latest prompt also supersedes the plan's single-profile MVP suggestion. |
| Master Plan four learning areas; PPT five navigation labels | Keep Home, Vocabulary, Grammar, Practice, Speaking at top level when the shell is built. Preserve Immersion in backlog; no invented finished screen. |
| Vocabulary Practice versus primary Practice | Slide 17 is vocabulary review and must work in Phase B. Primary Practice/Speaking stay explicitly deferred. |
| Mastery failure “back to practice” | Append an attempt, schedule Relearning/Review transactionally; never delete history. |
| Five rapid checkpoints versus mastery | Only spaced, delayed, varied, independent evidence may graduate an item. Evaluate a maintained FSRS package before selecting its version. |
| Slide 19 six example rows | Follow note: exactly five checked examples and Continue to Quiz. |
| Slide 16 duplicate “cancel” plus confirmation | Preserve form input, show possible matches and let the learner decide; different senses are legitimate. Custom examples remain unverified drafts. |
| Repeated vocabulary/grammar rows and sample dashboard counts | Use stable verified content IDs and real profile data; no storyboard values become seed data. |
| Master Plan launch dataset size / immersion versus latest phased brief | Begin with a tiny checked pack after profile persistence works; defer imports and Immersion UI. No external dataset claims/licenses treated as newly verified. |
| Original robots and latest variety request | Ten character pairs, selected for the local surface; stable varied assignments. White-backed black-line originals sit on white cards. Preserve all bytes. |
| Initial workspace contains starter documents only | No app, learner database, tests or Git repository existed. Build only a minimal scaffold while the Flutter SDK is unavailable. No architecture migration is involved. |
| Dependencies cannot be resolved/tested without Flutter | Do not invent a pubspec lockfile or handwritten Windows runner. First scaffold uses Flutter SDK only; add Riverpod/Drift with resolved compatible versions in the profile slice. |

## Recovery and change discipline

The original PPTX, Markdown specifications and robot images remain untouched. Keep existing dated project-memory decisions. Word is a generated mirror; canonical Markdown is the recovery source. Database creation was deferred at bootstrap; schema v1 is introduced below. Future schema changes require tested migration and recovery before use. No cloud, paid API, AI, analytics or runtime network dependency is introduced.

## 2026-11-03–04: first local-profile slice

- Installed official stable Flutter 3.47.9 / Dart 3.13.7 in `%TEMP%/nihao-tools/flutter`, with a separate task-local Pub cache. No global PATH change. `scripts/flutter.ps1` can use this SDK, an SDK on PATH, or `NIHAO_FLUTTER_ROOT`.
- Added and locked Riverpod/Drift dependencies; generated Drift code with build_runner and Windows runner with Flutter. This implements the approved architecture and introduces the first database; there was no prior learner schema to migrate.
- Schema v1 stores profiles and the last-selected profile ID, protected by foreign keys and fixed-value constraints. Creation and selection are transactional; returned state is read before commit. No delete/reset fallback exists. Unknown schema upgrades fail explicitly. Baseline schema is exported in `docs/schema/drift_schema_v1.json`.
- Profile names support Unicode, reject hidden/control and malformed characters, and have bounded length. Display names need not be unique: stable integer IDs keep same-name profiles distinct, and the picker shows the profile number. Name is a display label, never authentication or a database key.
- Each profile owns its level, purpose, daily-minute target and Pinyin preference. Time is injected into the repository and stored as UTC. Learning progress/events are deliberately deferred until the lesson slice; no empty progress schema or fake counters were added.
- Database location uses the OS application-support directory and `ni_hao_robot.sqlite`. Windows company/product metadata is fixed before any real learner database is created: company `Ni Hao Robot`, product `ni_hao_robot`. Changing these later requires explicit data-path migration; never silently create a fresh database elsewhere.
- Error retry is explicit, preserving drafts and saved data. Initial tests caught invisible Material feedback and a retry invalidation issue; both were fixed and regression-tested. Repeated submissions are disabled while saving.
- Native Windows checks need Visual Studio C++ and plugin symlink support. Widget tests and SQLite tests run separately with the resolved packages. Do not switch to web to conceal missing native tooling.

For recovery, keep the learner database intact and roll back code only when schema-compatible. Before future migrations, close the app and make a recoverable database backup; test restoration and migration on a copy. No real learner database was modified during this slice; test databases were temporary.

## 2026-11-04: Home, Vocabulary and foundation continuation

- Continue the approved next slice in Flutter while Windows native prerequisites remain missing. Home now hosts an optional first-use introduction entry, preserving access to profile switching. Five short purpose pages lead to Hanzi, Pinyin, tones and a greeting/parting exchange; Save and leave allows a later return. This reconciles slides 2–6 with the Master Plan's tiny foundation requirement.
- Schema v2 adds only per-profile introduction state and shares the existing database connection across repositories. v1 profiles/settings remain untouched. Migration/restart/backup restoration and rollback-on-write-error are tested. No real learner database was opened. `MIGRATIONS.md` records recovery; both schema snapshots are retained.
- Completion is an acknowledgement, not vocabulary or mastery evidence; replay never erases completion. Saved page order is stable for revision 1. Pinyin preference applies except where the page explicitly teaches Pinyin/tone marks.
- Home milestones explain thresholds but have no invented learned-word list, streak or weekly values. Their detailed metrics/tour steps will arrive with real lesson records. Vocabulary Learn/Practice/Master are honest landing cards, not fake action buttons. Grammar has a modest pending-content card and replayable tour. Primary Practice/Speaking retain the exact design-pending status; no new AI/voice UI.
- Tours spotlight and scroll to actual live controls/cards, with keyboard-operated Back/Next/Close and replay. Activities omit the sidebar. Narrow layouts wrap controls and scroll at 200% text scale.
- Added three byte-identical light-background originals: hover, orb and goggles. Different Vocabulary cards use different characters; source files and alpha were preserved.
- Introduction facts checked against Open University teaching references; no curriculum/audio imported. Native-teacher review, recordings and the five-example lesson pack remain later release gates. See `FOUNDATION_CONTENT.md`.
