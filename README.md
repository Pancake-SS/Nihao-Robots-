# Ni Hao Robot!

A Windows-first, local-first Mandarin learning companion built toward Flutter + Dart, Riverpod and Drift/SQLite. Simplified Chinese, tone-marked Pinyin, English guidance, and the user's original robots.

**Current status:** offline profiles, tours, introduction, and Learn → Quiz → scheduled Review are implemented. The app bundles a searchable **11,147-word offline dictionary**, ordered from basic to advanced, plus **21 starter lessons, five examples and eight questions each**, including both Hanzi/Pinyin directions, translated cloze and typed recall. Twenty imported lessons include **88 offline sentence recordings**. An object-oriented generator creates questions from imported words without AI calls. Independent teacher/listening review, grammar, adaptive scheduling and mastery remain pending. See [content/database design](docs/CONTENT_DATABASE.md) and [setup](docs/SETUP.md).

## Source reconciliation

Vocabulary → **Browse words** searches Hanzi, marked/numbered Pinyin or English. Open a lesson, play its available sentence audio, then **Continue to Quiz**. **Open reviews** shows real saved due dates. Initial checks and failed reviews schedule five minutes; successful due reviews schedule one day. This limited early-review policy does not award mastery. Lessons visibly retain source-checked-pilot status.

The full imported word library is accessible from Browse words. The staging import contains 11,147 HearMandarin words and 4,354 no7z sentences; the generator produces 2,349 draft questions for 300 band-one words. Zhongdex records are separately quarantined with provenance retained. Bulk candidates are not automatically published as reviewed lessons.

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
  features/vocabulary/  # Validated catalogue and five-example lessons
  features/review/      # Quiz, transactional attempts and early review schedule
  features/profiles/    # Validation, repository, Riverpod state and profile UI
  shared/               # Original robot display, cards and contextual tours
test/                   # Domain, SQLite, widget and UI/database-restart checks
assets/mascots/          # Six byte-identical bundle copies
assets/content/          # Two versioned packs, attribution and license texts
assets/audio/            # 88 original selected sentence recordings
content/                 # Source/audio locks and reviewed starter selection
Robot images/           # All 20 unchanged source PNGs
reference/              # Original specifications and storyboard
scripts/                # Bulk importer, OO question patterns, audits and tools
docs/                   # Requirements, assets, design, setup and memory
windows/                # SDK-generated native runner
pubspec.yaml            # Flutter/Riverpod/Drift and native storage helpers
pubspec.lock            # Actual resolved dependency versions
```

Schema v4 adds versioned content tables alongside existing per-profile progress and immutable attempts; v1–v4 snapshots are retained. Additive migration, backups, content upgrades, rollback and duplicate submissions are tested; see [migration notes](docs/MIGRATIONS.md). Core learning and bundled playback need no cloud account or network. Current verification: **73 Flutter tests and 17 Python tests pass; static analysis passes**. The updated Windows debug build and widget visual checks pass; native audible playback remains a manual check; see [project memory](docs/PROJECT_MEMORY.md) for their actual status.

## Prioritized roadmap

1. **A1 — Native Windows verification:** machine prerequisites, debug build and window launch pass. Complete the native profile/lesson/restart/resize smoke checks. Persistence and responsive UI are already covered by the Flutter test harness.
2. **A2 — Extend the working pilot:** obtain independent teacher review, add a readable attempt-history view, and select/test adaptive scheduling before claiming long-term mastery. The first journey already covers restart, profile isolation and exact due boundaries; no mastery is awarded.
3. **B — Complete vocabulary and starter grammar:** three stacks, diverse exercises, custom drafts/duplicate warnings, truthful mastery and real distinct prerequisite-based grammar. Expand the imported candidate bank through explicit content and rights review.
4. **Later:** primary Practice/Speaking, Immersion UI, optional AI/cloud/voice after design decisions. No current implementation claimed.

Canonical session handoff: [Project Memory](docs/PROJECT_MEMORY.md). Human mirror: [Development Journal](docs/Development_Journal.docx). Other source-derived documents: [slide requirements](docs/SLIDE_REQUIREMENTS.md), [asset manifest](docs/ASSET_MANIFEST.md), [design system](docs/DESIGN_SYSTEM.md).
