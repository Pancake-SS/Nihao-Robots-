# Ni Hao Robot!

A Windows-first, local-first Mandarin learning companion built toward Flutter + Dart, Riverpod and Drift/SQLite. Simplified Chinese, tone-marked Pinyin, English guidance, and the user's original robots.

**Current status:** offline profiles, tours, introduction and Learn > Quiz > scheduled Review are implemented. Browse **11,147 words and 85,118 questions** in separate pages of 20, with search, priority/category filters and a selected-word Learn button. Add your own words with five example sentences; they become linked lessons at the front of your profile's queue. **10,810 words** have FMLD meaning/usage enrichment. **7,099 words have sourced examples; 4,600 have recordings**, using 4,118 offline recordings. Words and unrecorded examples use installed device Mandarin TTS. Typed-answer questions include an offline **Pinyin-to-Hanzi keyboard** with candidate selection and optional on-screen keys. Each answer is checked immediately; missed questions return at the end until correct, while the saved first-try result remains honest. The supplied cozy UI artwork and varied robot designs are integrated. Question generation uses existing word data and now favors related wrong answers without AI calls. Independent teacher/listening review remains pending. See [content/database design](docs/CONTENT_DATABASE.md) and [setup](docs/SETUP.md).

## GitHub backup

Project source, bundled content, documentation and committed history are backed up to
[Nihao-Robots-](https://github.com/Pancake-SS/Nihao-Robots-) on `main`.
After reviewing and committing changes, run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\backup_github.ps1
```

The helper checks the remote, pushes without forcing and verifies the remote commit.
It does not stage files or create commits. Uncommitted changes, local learner data,
SDKs, caches and build outputs are not included. See [backup details](docs/GITHUB_BACKUP.md).

## Try the redesigned interface

Run `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build_windows.ps1` from the project root, then launch the executable path printed by the helper. Keep its nearby DLLs and data folder together. In VS Code, **Terminal > Run Build Task** runs the same safe-path build. The patch's separate `lib/preview_main.dart` is sample-data-only source; this project has no web scaffold, so the actual Windows build is the supported way to try the design.

## Source reconciliation

Vocabulary > **Browse words** opens the paged word browser. Select a card, use **Learn**, then **Continue to Quiz**. Previous/Next replaces the current page; filters combine priority with categories such as measure words, numbers and custom words. **Add word** checks Hanzi, Pinyin and English meaning for existing matches; a match moves to the front, while a new word opens a page for five Chinese/Pinyin/English sentences and an optional explanation. On typed questions, enter Pinyin in the built-in keyboard, choose a Hanzi candidate, then press **Check answer**. You can also type or paste Chinese directly. A wrong answer shows feedback and returns at the end of the quiz; all missed questions must be corrected before the attempt is saved. The saved review result uses first answers, so retries do not erase mistakes. Each word has seven or eight questions. The 21 prepared lessons retain five examples each; other imported lessons use zero to five available source examples. Source and review details are accessible through the lesson info button. Zhongdex records remain separately quarantined.

- Read the full Master Plan and Coding Standards under `reference/`, the implementation brief, and existing project memory.
- Rendered/inspected all 27 original PPT slides; extracted actual notes with `python-pptx` and inspected OOXML comment parts/relationships. No true PowerPoint comments exist. Generic note template footers are separated from requirements.
- Inspected all 20 original PNGs: ten character pairs. Black-line variants have opaque white backing; white-line variants are transparent. The integrated artwork uses distinct robots across welcome, Home, Vocabulary, lesson and quiz screens; all 20 original files match their source hashes.
- Local profiles replace slide 1 sign-in; Vocabulary Practice is separate from deferred primary Practice; failed mastery retains history. Full decisions: [decision log](docs/DECISION_LOG.md).

## Initial file tree

```text
lib/
  main.dart
  app/                  # Application and shared theme
  data/                 # Drift schema, generated queries and native connection
  features/onboarding/  # Welcome, introduction content, persistence and activity
  features/dashboard/   # Home and honest milestone explanations
  features/vocabulary/  # Paginated learning queue and linked lessons
  features/review/      # Quiz, transactional attempts and early review schedule
  features/profiles/    # Validation, repository, Riverpod state and profile UI
  shared/               # Original robot display, cards and contextual tours
test/                   # Domain, SQLite, widget and UI/database-restart checks
assets/mascots/          # Six byte-identical bundle copies
assets/content/          # Relational curriculum, prepared packs and attribution
assets/audio/            # 4,118 original selected sentence recordings
content/                 # Source/audio locks and reviewed starter selection
Robot images/           # All 20 unchanged source PNGs
reference/              # Original specifications and storyboard
scripts/                # Bulk importer, OO question patterns, audits and tools
docs/                   # Requirements, assets, design, setup and memory
windows/                # SDK-generated native runner
pubspec.yaml            # Flutter/Riverpod/Drift and native storage helpers
pubspec.lock            # Actual resolved dependency versions
```

Schema v5 adds linked curriculum/audio/questions and per-profile queues alongside existing progress and immutable attempts; v1-v5 snapshots are retained. Migration, backup recovery, failed-import rollback and queue persistence are tested; see [migration notes](docs/MIGRATIONS.md). Core learning and bundled playback need no cloud account or network. Actual verification results and remaining native listening checks are recorded in [project memory](docs/PROJECT_MEMORY.md).

## Prioritized roadmap

1. **A1 — Native Windows verification:** machine prerequisites, debug build and window launch pass. Complete the native profile/lesson/restart/resize smoke checks. Persistence and responsive UI are already covered by the Flutter test harness.
2. **A2 — Extend the working pilot:** obtain independent teacher review, add a readable attempt-history view, and select/test adaptive scheduling before claiming long-term mastery. The first journey already covers restart, profile isolation and exact due boundaries; no mastery is awarded.
3. **B — Complete vocabulary and starter grammar:** three stacks, diverse exercises, truthful mastery and real distinct prerequisite-based grammar. Expand the imported candidate bank through explicit content and rights review.
4. **Later:** primary Practice/Speaking, Immersion UI, optional AI/cloud/voice after design decisions. No current implementation claimed.

Canonical session handoff: [Project Memory](docs/PROJECT_MEMORY.md). Human mirror: [Development Journal](docs/Development_Journal.docx). Other source-derived documents: [slide requirements](docs/SLIDE_REQUIREMENTS.md), [asset manifest](docs/ASSET_MANIFEST.md), [design system](docs/DESIGN_SYSTEM.md).
