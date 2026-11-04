# Ni Hao Robot!

A Windows-first, local-first Mandarin learning companion built toward Flutter + Dart, Riverpod and Drift/SQLite. Simplified Chinese, tone-marked Pinyin, English guidance, and the user's original robots.

**Current status:** offline profiles, Home/Vocabulary navigation, contextual tours, a nine-step introduction and a first Learn → Quiz → scheduled Review pilot are implemented. The greeting lesson has five examples and two recognition questions; each profile's attempts and schedule survive restart. Audio, grammar lessons, adaptive scheduling and mastery remain pending. The native Windows debug build and responding app window now pass; full native functional smoke checks remain pending. See [setup and exact commands](docs/SETUP.md).

## Source reconciliation

Vocabulary → **Browse words** → **Explore word** → **Continue to Quiz** opens the bundled 你好 pilot. Vocabulary → **Open reviews** shows saved due dates. Initial checks and failed reviews schedule five minutes; successful due reviews schedule one day. This is a limited recognition policy, not FSRS or mastery. The lesson is explicitly source-checked with independent teacher review pending; see its [review record and references](docs/STARTER_GREETING_REVIEW.md).

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
assets/content/          # One explicitly labeled source-checked pilot
Robot images/           # All 20 unchanged source PNGs
reference/              # Original specifications and storyboard
scripts/                # Source audits, journal sync, runner bootstrap
docs/                   # Requirements, assets, design, setup and memory
windows/                # SDK-generated native runner
pubspec.yaml            # Flutter/Riverpod/Drift and native storage helpers
pubspec.lock            # Actual resolved dependency versions
```

Schema v3 adds per-profile vocabulary progress and attempt history; snapshots v1/v2/v3 are retained under `docs/schema/`. Additive migration, backup recovery, failed-write rollback and duplicate submissions are tested; see [migration notes](docs/MIGRATIONS.md). There is no cloud service, mandatory account or runtime network request in the implemented flows. Introduction fact checks are recorded in [content notes](docs/FOUNDATION_CONTENT.md). Current verification: 61 Flutter tests pass, static analysis passes, and 49 Dart files pass formatting. Desktop widget renders were inspected; native-process verification is still pending.

## Prioritized roadmap

1. **A1 — Native Windows verification:** machine prerequisites, debug build and window launch pass. Complete the native profile/lesson/restart/resize smoke checks. Persistence and responsive UI are already covered by the Flutter test harness.
2. **A2 — Extend the working pilot:** obtain independent teacher review, add a readable attempt-history view, and select/test adaptive scheduling before expanding the content bank. The first journey already covers restart, profile isolation and exact due boundaries; no mastery is awarded.
3. **B — Complete vocabulary and starter grammar:** three stacks, diverse exercises, custom drafts/duplicate warnings, truthful mastery and real distinct prerequisite-based grammar. Add curated imports/audio only after rights and content review.
4. **Later:** primary Practice/Speaking, Immersion UI, optional AI/cloud/voice after design decisions. No current implementation claimed.

Canonical session handoff: [Project Memory](docs/PROJECT_MEMORY.md). Human mirror: [Development Journal](docs/Development_Journal.docx). Other source-derived documents: [slide requirements](docs/SLIDE_REQUIREMENTS.md), [asset manifest](docs/ASSET_MANIFEST.md), [design system](docs/DESIGN_SYSTEM.md).
