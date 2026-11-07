# Ni Hao Robot!

A Windows-first, local-first Mandarin learning companion built toward Flutter + Dart, Riverpod and Drift/SQLite. Simplified Chinese, tone-marked Pinyin, English guidance, and the user's original robots.

**Current status:** offline profiles, tours, introduction and Learn > Quiz > scheduled Review are implemented. The learning queue covers **11,147 words and 82,595 questions**, ordered from basics to harder source bands. It loads **20 words at a time**, supports selection and saved reordering, and opens the selected word's lesson. Questions and sentence audio are linked through SQLite keys. **4,601 words have sourced examples; 4,600 have audio**, using 4,118 offline recordings. Missing coverage is shown honestly. Pattern-based question generation uses existing word data without AI calls. Independent teacher/listening review remains pending. See [content/database design](docs/CONTENT_DATABASE.md) and [setup](docs/SETUP.md).

## Source reconciliation

Vocabulary > **Browse words** opens the learning queue. Select a row, use **Learn**, then **Continue to Quiz**. **See 20 more** adds the next page; Move up/down/to front and Restore priority order save changes per profile. Search covers all remaining words. **Open reviews** shows saved due dates. Initial checks and failed reviews schedule five minutes; successful due reviews schedule one day. This early-review policy does not award mastery.

All words have seven or eight questions. The 21 prepared lessons retain five examples each; other lessons use zero to five available source examples and visibly remain source-imported, pending review. Zhongdex records remain separately quarantined.

- Read the full Master Plan and Coding Standards under `reference/`, the implementation brief, and existing project memory.
- Rendered/inspected all 27 original PPT slides; extracted actual notes with `python-pptx` and inspected OOXML comment parts/relationships. No true PowerPoint comments exist. Generic note template footers are separated from requirements.
- Inspected all 20 original PNGs: ten character pairs. Black-line variants have opaque white backing; white-line variants are transparent. Welcome uses waving/orb, Home uses tracked, and Vocabulary uses distinct hover/orb/goggles robots. All six bundled files are unchanged copies.
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
3. **B — Complete vocabulary and starter grammar:** three stacks, diverse exercises, custom drafts/duplicate warnings, truthful mastery and real distinct prerequisite-based grammar. Expand the imported candidate bank through explicit content and rights review.
4. **Later:** primary Practice/Speaking, Immersion UI, optional AI/cloud/voice after design decisions. No current implementation claimed.

Canonical session handoff: [Project Memory](docs/PROJECT_MEMORY.md). Human mirror: [Development Journal](docs/Development_Journal.docx). Other source-derived documents: [slide requirements](docs/SLIDE_REQUIREMENTS.md), [asset manifest](docs/ASSET_MANIFEST.md), [design system](docs/DESIGN_SYSTEM.md).
