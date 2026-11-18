# Ni Hao Robot!

A Windows-first, local-first Mandarin learning companion built toward Flutter + Dart, Riverpod and Drift/SQLite. Simplified Chinese, tone-marked Pinyin, English guidance, and the user's original robots.

**Current status:** offline profiles, introduction, Vocabulary, Master, Grammar and Learning are implemented. Browse **11,147 words and 85,118 questions** in pages of 20 with search and priority/category filters. Add a custom word with five examples to the front of the queue. **10,810 words** have FMLD meaning/usage enrichment; **7,099 words have sourced examples and 4,600 have recordings**, using 4,118 offline recordings. Words and unrecorded examples use installed device Mandarin TTS. Questions favor related wrong answers, check each answer and return missed questions at the end. Master tests require 25 correct points or can be started instantly, then save an ungraded writing prompt. Learning includes online resources, 139 offline classical readings with English companions, free writing and a single-page notebook. The Home page shows a green mastery bar and daily streak goals: ten new words, twenty quiz words, ten Master reviews and one saved writing piece. Profiles can be exported to and imported from a local JSON save. See [content/database design](docs/CONTENT_DATABASE.md), [classical story sources](docs/CLASSICAL_STORIES.md) and [setup](docs/SETUP.md).

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

## Move an account to another device

On the profile chooser, select **Export account save** beside the profile and save the JSON file. Install the current app on the other device, select **Import account save**, and choose that file. Import creates a new profile with its queue, progress, custom words, Master writing, grammar completions, free writing and notebook pages. The bundled word library and story content ship with the app and are not copied into the save. Keep the file private because it contains your writing and learning history.

## Try the redesigned interface

Run `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build_windows.ps1` from the project root, then launch the executable path printed by the helper. Keep its nearby DLLs and data folder together. In VS Code, **Terminal > Run Build Task** runs the same safe-path build. The patch's separate `lib/preview_main.dart` is sample-data-only source; this project has no web scaffold, so the actual Windows build is the supported way to try the design.

## Source reconciliation

Vocabulary > **Browse words** opens the paged word browser. Select a card, use **Learn**, then **Continue to Quiz**. Previous/Next replaces the current page; filters combine priority with categories such as measure words, numbers and custom words. **Add word** checks Hanzi, Pinyin and English meaning for existing matches; a match moves to the front, while a new word opens a page for five Chinese/Pinyin/English sentences and an optional explanation. Use the English, Hanzi, Pinyin or All mode above each editor. In Hanzi mode, type Pinyin directly in the Hanzi field and choose a candidate or press Space; paste and installed Chinese IMEs also work. All shows Hanzi · Pinyin · English on one line and fills the three fields when a dictionary choice is selected. Check the editable English gloss before saving a full sentence. Sentence entries remain saved while scrolling. Typed quiz answers use the same inline Hanzi conversion. A wrong answer shows feedback and returns at the end of the quiz; all missed questions must be corrected before the attempt is saved. The saved review result uses first answers, so retries do not erase mistakes. Each word has seven or eight questions. The 21 prepared lessons retain five examples each; other imported lessons use zero to five available source examples. Source and review details are accessible through the lesson info button. Zhongdex records remain separately quarantined.

- Read the full Master Plan and Coding Standards under `reference/`, the implementation brief, and existing project memory.
- Rendered/inspected all 27 original PPT slides; extracted actual notes with `python-pptx` and inspected OOXML comment parts/relationships. No true PowerPoint comments exist. Generic note template footers are separated from requirements.
- Inspected all 20 original PNGs: ten character pairs. Black-line variants have opaque white backing; white-line variants are transparent. The integrated artwork uses distinct robots across welcome, Home, Vocabulary, lesson and quiz screens; all 20 original files match their source hashes.
- Local profiles replace slide 1 sign-in. Vocabulary lessons and Master tests supply quiz activity; the separate Practice destination has been removed. Failed Master reviews retain history. Full decisions: [decision log](docs/DECISION_LOG.md).

## Initial file tree

```text
lib/
  main.dart
  app/                  # Application and shared theme
  data/                 # Drift schema, generated queries and native connection
  features/onboarding/  # Welcome, introduction content, persistence and activity
  features/dashboard/   # Home, mastery bar and daily streak
  features/vocabulary/  # Paginated learning queue and linked lessons
  features/review/      # Quiz, Master tests and Master review
  features/profiles/    # Profiles and portable account saves
  features/grammar/     # Pending and completed grammar lessons
  features/learning/    # Stories, resources, writing and notebook
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

## Remaining work

Independent Mandarin teacher and listening review is still needed for imported examples, dictionary enrichment, generated questions and device TTS. Speaking is a placeholder. The Windows build script creates a portable package; keep the executable with its nearby DLLs and data folder.

Canonical session handoff: [Project Memory](docs/PROJECT_MEMORY.md). Human mirror: [Development Journal](docs/Development_Journal.docx). Other source-derived documents: [slide requirements](docs/SLIDE_REQUIREMENTS.md), [asset manifest](docs/ASSET_MANIFEST.md), [design system](docs/DESIGN_SYSTEM.md).
