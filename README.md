# Ni Hao Robot!

A Windows-first, local-first Mandarin learning companion built toward Flutter + Dart, Riverpod and Drift/SQLite. Simplified Chinese, tone-marked Pinyin, English guidance, and the user's original robots.

**Current status:** offline local profiles implemented with Riverpod and Drift/SQLite. Create, choose and continue with independent level/goal/Pinyin settings; the last selection survives restart. Flutter widget/database tests cover this flow. Native Windows launch still requires machine toolchain setup. Lessons, quizzes, learning progress and tutorials remain pending. See [setup and exact commands](docs/SETUP.md).

## Source reconciliation

- Read the full Master Plan and Coding Standards under `reference/`, the implementation brief, and existing project memory.
- Rendered/inspected all 27 original PPT slides; extracted actual notes with `python-pptx` and inspected OOXML comment parts/relationships. No true PowerPoint comments exist. Generic note template footers are separated from requirements.
- Inspected all 20 original PNGs: ten character pairs. Black-line variants have opaque white backing; white-line variants are transparent. Profile entry uses waving/orb robots; the profile-ready screen uses the tracked robot. All three bundled files are unchanged copies.
- Local profiles replace slide 1 sign-in; Vocabulary Practice is separate from deferred primary Practice; failed mastery retains history. Full decisions: [decision log](docs/DECISION_LOG.md).

## Initial file tree

```text
lib/
  main.dart
  app/                  # Application and shared theme
  data/                 # Drift schema, generated queries and native connection
  features/onboarding/  # Welcome composition
  features/profiles/    # Validation, repository, Riverpod state and profile UI
  shared/               # Original robot display
test/                   # Domain, SQLite, widget and UI/database-restart checks
assets/mascots/          # Three byte-identical bundle copies
Robot images/           # All 20 unchanged source PNGs
reference/              # Original specifications and storyboard
scripts/                # Source audits, journal sync, runner bootstrap
docs/                   # Requirements, assets, design, setup and memory
windows/                # SDK-generated native runner
pubspec.yaml            # Flutter/Riverpod/Drift and native storage helpers
pubspec.lock            # Actual resolved dependency versions
```

Database schema v1 is exported under `docs/schema/` for future migrations. There is no cloud service, mandatory account or runtime network request in the profile flow.

## Prioritized roadmap

1. **A1 — Native Windows verification:** complete the Windows machine prerequisites and smoke-test the implemented profile flow in a native build. Profile persistence and responsive UI are already covered by the Flutter test harness.
2. **A2 — First learning journey:** Home/Vocabulary shell, first-run foundations/tutorial, tiny checked content pack, one Learn → Quiz → scheduled Review journey; restart persistence and injected-clock tests. No invented counters or mastery.
3. **B — Complete vocabulary and starter grammar:** three stacks, diverse exercises, custom drafts/duplicate warnings, truthful mastery and real distinct prerequisite-based grammar. Add curated imports/audio only after rights and content review.
4. **Later:** primary Practice/Speaking, Immersion UI, optional AI/cloud/voice after design decisions. No current implementation claimed.

Canonical session handoff: [Project Memory](docs/PROJECT_MEMORY.md). Human mirror: [Development Journal](docs/Development_Journal.docx). Other source-derived documents: [slide requirements](docs/SLIDE_REQUIREMENTS.md), [asset manifest](docs/ASSET_MANIFEST.md), [design system](docs/DESIGN_SYSTEM.md).
