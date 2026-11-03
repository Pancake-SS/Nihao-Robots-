# Ni Hao Robot!

A Windows-first, local-first Mandarin learning companion built toward Flutter + Dart, Riverpod and Drift/SQLite. Simplified Chinese, tone-marked Pinyin, English guidance, and the user's original robots.

**Current status:** requirements and artwork audited; minimal Flutter welcome source scaffold only. Flutter/Dart are unavailable in this environment, so the app has not been built or tested. Profiles, lessons and persistence are the next slice. See [setup and exact commands](docs/SETUP.md).

## Source reconciliation

- Read the full Master Plan and Coding Standards under `reference/`, the implementation brief, and existing project memory.
- Rendered/inspected all 27 original PPT slides; extracted actual notes with `python-pptx` and inspected OOXML comment parts/relationships. No true PowerPoint comments exist. Generic note template footers are separated from requirements.
- Inspected all 20 original PNGs: ten character pairs. Black-line variants have opaque white backing; white-line variants are transparent. The scaffold uses two different robots on appropriate surfaces, copied without changes.
- Local profiles replace slide 1 sign-in; Vocabulary Practice is separate from deferred primary Practice; failed mastery retains history. Full decisions: [decision log](docs/DECISION_LOG.md).

## Initial file tree

```text
lib/
  main.dart
  app/                  # Application and shared theme
  features/onboarding/  # Welcome scaffold; profile flow next
  shared/               # Original robot display
test/                   # Flutter widget checks (not run yet)
assets/mascots/          # Two byte-identical bundle copies
Robot images/           # All 20 unchanged source PNGs
reference/              # Original specifications and storyboard
scripts/                # Source audits, journal sync, runner bootstrap
docs/                   # Requirements, assets, design, setup and memory
pubspec.yaml            # Flutter SDK only until dependency validation
```

Add `data/`, `core/` and feature directories when their vertical slice needs them. Generated `windows/` and `pubspec.lock` follow SDK setup, not handwritten substitutes.

## Prioritized roadmap

1. **A1 — Tooling and profiles:** validate Flutter on Windows; install/lock Riverpod and Drift; create/select/continue offline profiles with persistence and isolation tests.
2. **A2 — First learning journey:** Home/Vocabulary shell, first-run foundations/tutorial, tiny checked content pack, one Learn → Quiz → scheduled Review journey; restart persistence and injected-clock tests. No invented counters or mastery.
3. **B — Complete vocabulary and starter grammar:** three stacks, diverse exercises, custom drafts/duplicate warnings, truthful mastery and real distinct prerequisite-based grammar. Add curated imports/audio only after rights and content review.
4. **Later:** primary Practice/Speaking, Immersion UI, optional AI/cloud/voice after design decisions. No current implementation claimed.

Canonical session handoff: [Project Memory](docs/PROJECT_MEMORY.md). Human mirror: [Development Journal](docs/Development_Journal.docx). Other source-derived documents: [slide requirements](docs/SLIDE_REQUIREMENTS.md), [asset manifest](docs/ASSET_MANIFEST.md), [design system](docs/DESIGN_SYSTEM.md).
