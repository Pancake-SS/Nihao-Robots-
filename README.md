# Ni Hao Robot!

A Windows-first, local-first Mandarin learning companion built toward Flutter + Dart, Riverpod and Drift/SQLite. Simplified Chinese, tone-marked Pinyin, English guidance, and the user's original robots.

**Current status:** offline profiles, Home/Vocabulary navigation, replayable contextual tours and a nine-step introduction are implemented. Each profile retains its introduction position and completion after restart. Vocabulary/grammar lessons, quizzes, audio and review scheduling remain pending; no learning statistics are fabricated. Native Windows launch still requires machine toolchain setup. See [setup and exact commands](docs/SETUP.md).

## Source reconciliation

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
  features/vocabulary/  # Landing cards; learning activities pending
  features/profiles/    # Validation, repository, Riverpod state and profile UI
  shared/               # Original robot display, cards and contextual tours
test/                   # Domain, SQLite, widget and UI/database-restart checks
assets/mascots/          # Six byte-identical bundle copies
Robot images/           # All 20 unchanged source PNGs
reference/              # Original specifications and storyboard
scripts/                # Source audits, journal sync, runner bootstrap
docs/                   # Requirements, assets, design, setup and memory
windows/                # SDK-generated native runner
pubspec.yaml            # Flutter/Riverpod/Drift and native storage helpers
pubspec.lock            # Actual resolved dependency versions
```

Schema v2 adds only per-profile introduction state; both schema snapshots are retained under `docs/schema/`. Migration and backup recovery are tested; see [migration notes](docs/MIGRATIONS.md). There is no cloud service, mandatory account or runtime network request in the implemented flows. Introduction fact checks and release limits are recorded in [content notes](docs/FOUNDATION_CONTENT.md).

## Prioritized roadmap

1. **A1 — Native Windows verification:** complete the Windows machine prerequisites and smoke-test the implemented profile flow in a native build. Profile persistence and responsive UI are already covered by the Flutter test harness.
2. **A2 — First learning journey:** the shell, introduction and tours are complete. Next: a tiny checked content pack and one Learn → Quiz → scheduled Review journey, with restart persistence and injected-clock tests. No invented counters or mastery.
3. **B — Complete vocabulary and starter grammar:** three stacks, diverse exercises, custom drafts/duplicate warnings, truthful mastery and real distinct prerequisite-based grammar. Add curated imports/audio only after rights and content review.
4. **Later:** primary Practice/Speaking, Immersion UI, optional AI/cloud/voice after design decisions. No current implementation claimed.

Canonical session handoff: [Project Memory](docs/PROJECT_MEMORY.md). Human mirror: [Development Journal](docs/Development_Journal.docx). Other source-derived documents: [slide requirements](docs/SLIDE_REQUIREMENTS.md), [asset manifest](docs/ASSET_MANIFEST.md), [design system](docs/DESIGN_SYSTEM.md).
