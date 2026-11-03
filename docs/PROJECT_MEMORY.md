# Ni Hao Robot! — Project Memory

_Last updated: 2026-11-03 | State: source audit complete; minimal Flutter source scaffold; SDK checks blocked_

## Project vision and invariants
- Science-informed Mandarin learning companion for beginners: Simplified Chinese, tone-marked Pinyin, clear English explanations.
- Adopt Flutter + Dart, Riverpod, SQLite/Drift, Windows first, Android later; offline learning is required.
- UI: cozy warm cream/pastels, navy contrast, rectangular polished app screens; lighter backgrounds on subpages; top-level navigation sidebar only.
- Preserve uploaded original black-and-white robot art **exactly**. Do not redraw or invent variants.
- Latest artwork instruction: use distinct robots across screens and the supplied variant appropriate to its local surface. Light versions have opaque white backing; white-line versions have transparency for dark surfaces. Never infer pairs from filename suffixes.
- Top-level Practice and Speaking interfaces are not yet designed. Vocabulary's internal Review/Practice **is** designed. Immersion has product requirements but no final PPT design.
- Slide visuals set mood/structure, not pixel-perfect implementation. Speaker notes and any comments matter for actual behavior.
- Maintain verified educational content, deterministic scoring/scheduling, durable learner progress, and tested migrations.

## Sources read and independently verified
- `reference/Mandarin_Learning_App_Master_Plan(1).md` — full product plan; `reference/CODING_STANDARDS(1).md` — full testing/security/architecture standards.
- Attached implementation prompt, workspace `NI_HAO_ROBOT_VSCODE_MASTER_PROMPT.md`, `START_HERE.md`, original project memory and existing Word journal. The Word starter contained no extra history beyond Markdown.
- `reference/Copy of MCPKI_FYP_Starred_Slides_Updated.pptx.pptx` — all 27 slides rendered with PowerPoint read-only and inspected. All linked note bodies extracted using python-pptx; 17 notes parts. Notes part numbers do not match slide numbers. Real classic/modern comment/author parts and related references: zero.
- `reference/POWERPOINT_SPEAKER_NOTES.md` was compared with original notes. Slide 13 has an empty note; slides 20–25 have generic footer bodies only. Template tokens on slide 15 are excluded from requirements. Full mapping and verbatim bodies: `docs/SLIDE_REQUIREMENTS.md`.
- All 20 PNGs under `Robot images/` inspected on cream/navy; ten distinct character pairs, 1254 × 1254 each. Exact paths, hashes, alpha information and varied assignments: `docs/ASSET_MANIFEST.md` and `docs/asset_inventory.json`. No source mascot is missing.

## Current implementation status
- Phase A bootstrap only. Original workspace had no app, learner database, tests or Git repository. Git is now initialized; source preservation and ignore rules are in place.
- Source-only Flutter welcome composition: `lib/main.dart`, `lib/app/app.dart`, `lib/app/theme.dart`, `lib/features/onboarding/welcome_screen.dart`, `lib/shared/robot_art.dart`. Two different supplied robots appear on white/navy surfaces; copies match original SHA-256 values. No generated replacement artwork.
- `pubspec.yaml` currently depends only on Flutter SDK. Riverpod and Drift remain approved but await compatible dependency resolution and tests in the profile slice. No handwritten generated runner/Drift code or invented lockfile.
- `test/welcome_screen_test.dart` contains four intended widget checks: honest pending state/artwork, narrow 200% text scaling, and two desktop sizes. These have NOT RUN. Runtime rendering, font fallback and responsiveness are not verified.
- No profile picker, database, progress counters, learning content, audio, quiz, scheduling or tutorial is implemented. Welcome copy clearly marks profiles/lessons as coming soon. No learning feature is claimed complete.
- Required slide, asset, design and decision documents exist. `README.md` includes the compact tree and phased roadmap. `docs/SETUP.md` supplies exact commands. `scripts/bootstrap_windows.ps1` generates only missing runner/metadata through the installed Flutter SDK in a temporary scaffold.

## Key decisions already agreed
- 2026-11-03: Use Flutter/Riverpod/Drift; local profiles instead of fake/login cloud authentication for MVP. Slide 1's signup concept becomes Create Local Profile; real cloud auth is later.
- 2026-11-03: Keep top-level Practice/Speaking deferred; implement actual Vocabulary Review/Practice separately.
- 2026-11-03: On failed mastery test, return word to review/relearning without wiping history.
- 2026-11-03: PowerPoint slide 19's notes specify five example sentences + Continue button. Slide 26's grammar entries must be real database records, not repeated placeholders.
- 2026-11-03: Need `docs/SLIDE_REQUIREMENTS.md` and `docs/ASSET_MANIFEST.md` grounded in actual sources and imported assets.
- 2026-11-03: Source reconciliation completed in `docs/DECISION_LOG.md`. Multiple local profiles supersede the older single-profile plan; no mandatory login. Product milestones are not fluency guarantees. Custom-word examples stay unverified drafts; duplicate warnings preserve input and allow legitimate senses.
- 2026-11-03: Honor latest robot variety instruction through explicit character pairs and stable roles. Welcome uses waving black-line original on white and orb white-line original on navy. Background removal is unnecessary and not authorized.
- 2026-11-03: Missing Flutter tooling limits this session to a minimal scaffold. Do not substitute React/web or silently expand into untestable learning features. Next slice adds Riverpod/Drift only after SDK validation.

## Work log (dated; factual entries only)
- 2026-11-03 — Created initial planning/journal template. No Flutter app features or test runs claimed.
- 2026-11-03 — Bootstrap decision before changes: original workspace contains documents, scripts and 20 PNGs only; no application/database/tests/Git repository. Flutter/Dart unavailable on PATH and checked common SDK locations. Scope is source audit, required documentation and a minimal source-only welcome scaffold. Riverpod/Drift and local profile persistence remain the next testable slice; no unverified learning flow will be claimed.
- 2026-11-03 — Asset audit: ten distinct characters in 20 original PNGs; opaque white-backed black-line variants and transparent white-line variants. Explicit pair mapping is required because suffix numbers differ. Preserve originals, use varied stable assignments and white backing cards for light variants.
- 2026-11-03 — Completed 27-slide requirements audit and original artwork inventory; created design tokens, source decision log, setup guide and source-only welcome scaffold. No original source file was overwritten.
- 2026-11-03 — Improved `scripts/sync_journal.py` with real numbered lists, heading pagination and atomic replacement; added five passing regression tests in `scripts/test_sync_journal.py`. Existing dated decisions retained. Python documentation tools are isolated in ignored `.venv/`.
- 2026-11-03 — Verification: 27 slide records complete; no true comment records; all 20 original hashes unchanged, both bundle copies identical, alpha totals valid. PowerShell bootstrap parses and refuses missing SDK without creating a runner. Word visual render remains unavailable (LibreOffice absent; hidden Word fallback did not produce output).

## Active task and blockers
- Active handoff: install/locate Flutter and Windows compiler, then validate scaffold and begin the local-profile persistence slice.
- Flutter/Dart absent from PATH and checked common SDK locations. Windows native toolchain readiness cannot be certified without Flutter doctor. Use `docs/SETUP.md`; no SDK was installed in this session.
- DOCX rendering: LibreOffice absent; canonical renderer failed on missing soffice. Hidden read-only Word automation fallback stalled and its task-owned process was closed. Word synchronization is possible, but visual page-layout QA remains NOT RUN.
- Content pack, audio licensing and FSRS version are not yet selected/verified. These block a learning release, not the source scaffold. No consequential architecture change needs approval now.

## Tests/checks actually run
- dart format: NOT RUN — Dart SDK unavailable. Run the formatter in write mode, then the mandatory no-change gate after setup.
- flutter analyze: NOT RUN — Flutter SDK unavailable.
- flutter test: NOT RUN — Flutter SDK unavailable; four widget checks authored only.
- Relevant app integration/manual checks: NOT RUN — no executable build, Windows runner or database yet.
- Python journal regression suite: PASS, 5 tests (Unicode/emphasis preservation, numbering/restarts, headings, failed serialization preservation, missing-source preservation). Python compilation of scripts: PASS.
- PowerPoint audit: PASS, 27 slides, 17 notes parts, zero comment/author parts and references; all original slides rendered and visually reviewed. All 27 requirement entries have design, notes/comments, flow, decisions and deferred items.
- Asset audit: PASS, 20 decoded images, unique hashes, correct alpha totals, all originals unchanged; 2 bundled copies match sources exactly. In-app contrast/layout remains untested.
- Bootstrap script: syntax PASS; missing-SDK guard PASS (expected nonzero exit with explicit error; no runner created). Full runner generation NOT RUN. Direct script execution initially hit Windows execution policy; documented process-only Bypass command exercised the guard successfully.
- Journal synchronization and structural/content QA: PASS — valid DOCX package and all 76 content paragraphs match canonical Markdown. Markdown: YES; Word: YES. Final visual QA: NOT RUN — canonical renderer attempted on the updated file and fails without LibreOffice; Word fallback unavailable. No visual-quality claim.

## Design and technical backlog
1. Validate Windows Flutter toolchain and source scaffold; resolve/lock Riverpod and Drift for profile persistence.
2. Create/select/continue local profiles with validation, settings, isolated durable data and error states.
3. Home/Vocabulary shell, first-run Foundation and replayable tutorials; tiny checked content pack and Learn → Quiz → scheduled Review flow with restart persistence.
4. Complete vocabulary stacks, custom drafts/duplicate warnings, varied tests, immutable history and evidence-based mastery; distinct starter grammar/prerequisites.
5. Curated import versions/audio rights and stronger integration tests; expand only after content review.
6. Later: Immersion, primary Practice, Speaking/AI, cloud sync and voice after design and approval. Keep undesigned destinations explicitly pending.

## Next three concrete tasks
1. **Toolchain validation:** Follow `docs/SETUP.md`; Flutter doctor supports Windows, runner generated without overwriting source, package lock created, format/analyze/four widget checks pass; visually inspect 1440 × 900, 900 × 700 and 360 × 640 with 200% text.
2. **Local profiles:** Add reviewed Riverpod/Drift dependencies, typed schema/repository and Create / Choose / Continue UI. Acceptance: two offline profiles persist after restart, invalid names preserve input, errors are visible, progress is isolated and database/widget tests pass.
3. **First learning journey:** Add a tiny reviewed fixture pack with exactly five checked examples per word, Foundation/tutorial and one Learn → Quiz → Review schedule. Acceptance: deterministic grading, configurable early due step through injected clock, transactional deduplicated attempts, restart persistence, honest unavailable audio and no mastery from quick clicks; integration test passes.

## Open questions / decisions requiring later approval
- Final public app name/branding (the PowerPoint uses “Ni Hao Robot!” as a working name).
- Exact FSRS package/version after compatibility test.
- Final datasets and permitted local audio/TTS approach after licensing/quality checks.
- Final UI and implementation scope for top-level Practice, Speaking, and Immersion.
- When/if real cloud accounts and sync are required.

## Change/report rules
- Record implemented vs planned honestly; list modified files, tests run, failures, pending items.
- For each session, read this file at start. After any meaningful feature slice, decision, blocker or scope change, update it and run `python scripts/sync_journal.py` to regenerate `docs/Development_Journal.docx`.
- Keep this Markdown as canonical machine-readable memory; the Word file is the synchronized human-facing mirror. Do not erase historical decisions or invent test successes.
