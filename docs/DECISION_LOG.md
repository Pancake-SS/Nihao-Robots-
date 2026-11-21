# Ni Hao Robot! — Decision log

## 2026-11-15: user-directed Practice redesign

The user's latest request supersedes the earlier plan to gate vocabulary reviews by time and defer the main Practice area. Practice is now available from both the sidebar and Vocabulary. A word's score is the number of questions answered correctly on the first try across saved attempts. Full-word replay, a user-chosen number of distinct random words, and an endless question deck use learned words from the selected profile. A missed question returns at the end of its round. Relearning uses Hanzi or English meaning to open a lesson; Pinyin is not a lookup key. Existing schedule columns and attempt snapshots are retained for database compatibility and migration, while new attempts create no delayed schedule.

## 2026-11-06: imported vocabulary and reusable question patterns

The user explicitly requested bulk real-data imports, more question directions, object-oriented pattern generation and existing sentence/audio sources. Added pinned HearMandarin/no7z imports, a separate staging database, an extensible Python question strategy hierarchy and additive app content schema v4. Generation and grading have no AI/network dependency. Twenty imported lessons plus the existing greeting publish eight questions each; the broader generated bank remains draft.

Zhongdex records are retained in quarantine with original license metadata because its NOTICE flags unresolved upstream HSK provenance. Exact Hanzi/Pinyin crosswalks are candidates, not reviewed sense equivalence. Its unhosted audio metadata cannot supply playback files. Selected no7z sentence recordings are bundled with CC BY-SA attribution and labeled synthetic; word audio remains unavailable. Source comparison does not replace independent teacher/listening review. No original artwork or learner records were altered.

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

## 2026-11-04: catalogue and word-introduction infrastructure

Connect the structurally validated content parser to an application-owned bundled asset list and catalogue UI, retaining pack revision and sense identity. Validate the whole catalogue before exposure; reject conflicting IDs rather than silently picking a revision. No approved pack exists yet, so production honestly shows an empty catalogue. Synthetic fixture content stays under tests/development tooling. The word view provides exactly five examples, profile-controlled Pinyin, source/review details and absent-audio text. Defer slide 19's Continue to Quiz button until an actual quiz route exists; no nonfunctional control or learning credit is added. No schema or learner-data changes.

## 2026-11-04: first pilot Learn → Quiz → Review

- The user lifted the temporary low-usage constraint and asked to continue. Implement the next bounded journey using one greeting sense, preserving the native Flutter/offline architecture and existing artwork.
- Distinguish an AI editorial/source check from independent teacher approval. Content schema 2 supports `source-checked-pilot`; the bundled lesson and UI explicitly state teacher review is pending. Exact sources, tone conventions, example checks and answer keys are recorded in `STARTER_GREETING_REVIEW.md`. No third-party dialogue, recording or image is imported.
- Use two small recognition tasks: Hanzi → meaning and meaning → Hanzi. This partially implements the quiz family; it does not claim slide 22's Pinyin task, productive retrieval, audio assessment or mastery. The slide-19 Continue to Quiz control is now wired.
- Implement an injectable early-review policy: first success or any failure → five minutes; successful due review → one day. This limited pilot policy is not FSRS or adaptive long-term scheduling. Retain all failed attempts and never graduate based on repeated recognition alone.
- Database schema 3 adds attempts and progress atomically; keep previous schema snapshots. Save stable sense identity, pack revision, question snapshot, selected answers and resulting schedule. Guard duplicate event IDs, stale progress versions and due eligibility. Freeze submitted UI answers so a save retry cannot alter a potentially committed payload.
- Review counts derive from the active profile's persisted rows. Content removal retains history and explains unavailability. Main Practice/Speaking, grammar lessons, Master and dashboard metrics remain pending. Next incremental UI is a readable attempt-history view.
- Existing native build prerequisites remain unresolved. All 61 Flutter tests, analysis and formatting pass; desktop pilot widget renders were inspected. Native-process acceptance remains NOT RUN. No new dependency or artwork changes.

## 2026-11-06: complete dictionary, learning order and editor workflow

The user explicitly requested continued import into the app, priorities and repair of the supplied CMake error. Bundle the full 11,147-word read-only dictionary alongside 21 prepared lessons rather than pretending all candidate examples are reviewed. Use an explicit foundation list followed by HSK bands; retain missing bands as unranked. Priorities guide ordering without locking harder words. Existing learner attempts remain untouched.

The supplied VS Code command bypassed Flutter generation. Disable CMake auto-configuration in the previously user-owned workspace settings and add a Flutter build task; this targeted change is now authorized by the bug request. Keep generated files owned by Flutter. Restore the same pinned SDK in persistent LocalAppData because the Temp installation became incomplete; preserve the old installation and global PATH.


## 2026-11-10: native Chinese input and GitHub backups

The user suggested https://github.com/dusionlike/zh-keyboard. Its documented
integration targets are Vue/React with a RIME WASM Pinyin engine. For this native
Flutter application, implement Pinyin composition and candidate selection using
the existing licensed offline word dictionary, with no web runtime or copied
upstream code. Handwriting and unrestricted sentence prediction are not included.
The input engine never receives the current quiz answer and does not change grading.

User authorized project backups at https://github.com/Pancake-SS/Nihao-Robots-.
Configure origin, align local/remote main branches, upload reviewed committed
history, and provide a non-forcing backup helper with remote-hash verification.
Learner data, caches and uncommitted edits remain local; no scheduled upload is added.

## 2026-11-16: Practice pages and Master progression

Practice opens as four short routes: one learned word, a chosen count of distinct random words, endless original questions without repeats, and Hanzi/English relearning. Master membership is a separate profile-owned table. At 25 cumulative correct first responses, a word becomes eligible for the full Master test; Instant master starts the same test sooner. After the full test, one randomized writing prompt is saved without semantic grading. Master practice uses three missed-answer chances per word in a session; the third moves it to Learn. Preserve all earlier correctness points, attempts and writing when this happens. On a new Learn attempt, derive the version from immutable history to avoid reusing a unique attempt version. Export schema v7 separately from historical versions when the Drift CLI export completes.

## 2026-11-17: grammar lessons

The user's uploaded HSK 3.0 JSON is the complete lesson catalogue, with beginner sentence patterns promoted to the front. Grammar has only Pending and Completed lists; completion is a reversible study marker, with no Practice or Master logic. Store shared source content separately from profile completion in schema v8. Enrich only 19 manually verified points with the matching AllSet article, rather than guessing a match for broad or ambiguous points. Show the AllSet source and article link wherever its content appears, as requested by that source's license. Use the installed Mandarin voice for example audio and preserve examples without source Pinyin as such.

## 2026-11-18: Learning means immersion and personal creation

The user's latest request separates Learning from vocabulary relearning. Add a sixth sidebar destination, Learning, with three routes: Explore online, Free writing and Notebook. Keep vocabulary Practice and Master writing as their own flows. Start the resource hub with a reviewed, code-owned set of 19 free-access links. Open original sites in the system browser; copy no third-party media or transcripts. Make access labels honest where free and paid sections coexist. Store free-writing pieces and notes together in the additive schema-9 `learning_entries` table with profile ownership and distinct kinds. Use original randomized writing topics, no automatic grading, and the existing four-mode Chinese keyboard in both editors. Keep Save visible and confirm discarding unsaved edits.

## 2026-11-19: Offline classical stories

The three user-supplied Wikisource works are bundled as 139 ordered readings under a separate Classical stories page in Learning. Keep the text in simplified rendering with source credit and pinned chapter links. Mark it as Classical Chinese rather than graded modern Mandarin. Import with a small number of batch API requests, preserve source revisions, and reject incomplete or unprocessed markup. The original index links also appear in Explore online. No learner database change is needed.

## 2026-11-21: Simpler Master and visible milestones

The user removed the post-quiz Master writing requirement and gallery. A passed regular full quiz now grants Master status directly. Keep the separate Free writing feature and keep historical `master_writings` rows in account saves without showing them in Master. The Mastered words page is a paged practice list. The home mastery bar uses current Master membership and shows flag goals at 100, 500, then each thousand through 11,000 words; the installed library still contains 11,147 words. Daily Master reviews count responses after the current Master timestamp or a historical Master writing timestamp.

Instant master is available from selected words in Learn and from the lesson as well as the Master search. The user clarified that it should bypass both the 25-point wait and the quiz for words already known. Every entry point confirms the direct promotion first; cancelling leaves the word unchanged. Regular Master still requires 25 points and a passed full quiz.

## 2026-11-22: Browse Practice and Master words before searching

One-word Practice and relearning, including their Master variants, now show learned words immediately in 20-word pages. Each row offers a direct Test or Lesson action; selecting a row still highlights it for the bottom action. Hanzi/English search narrows the pages, with Pinyin omitted from relearning search to avoid homophone collisions. Instant Master now pages through all unmastered curriculum words and still supports Hanzi, Pinyin and English search. The data queries return only 20 visible rows and one lookahead row per page.

## 2026-11-22: Compose unlisted words with the offline keyboard

The bundled word dictionary omits some valid compounds and standalone characters. The keyboard may now suggest a character from a dictionary word when its syllables align with its Hanzi characters. It labels the source word rather than presenting the derived character as an independent dictionary entry. If a complete Pinyin string has no word match, offer the first syllable's character candidates and retain the remaining Pinyin for a second selection. Keep whole-word matches first, preserve paging for homophones, and show candidate page controls before the buttons. The reported `binggui` example can be entered as 冰 + 柜, with 柜 attested in 柜子.
