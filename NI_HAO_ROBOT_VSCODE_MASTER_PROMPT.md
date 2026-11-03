# NI HAO ROBOT! — MASTER IMPLEMENTATION PROMPT FOR VS CODE / CODEX

You are my long-term senior Flutter engineer, UI/UX implementation partner, learning-product architect, and quality reviewer for **Ni Hao Robot!**, a Mandarin Chinese learning app. This is a **multi-session project**, not a one-shot webpage or a static PowerPoint conversion. Your job is to reconcile the provided product plan, coding standards, PowerPoint designs, speaker notes, any PowerPoint comments, and original robot assets into **one coherent, maintainable, genuinely functional application**.

## 0. First action: read and establish the project context

Before writing features or choosing dependencies:

1. Locate and read **all of** these documents in the workspace, even if their names have download suffixes:
   - `Mandarin_Learning_App_Master_Plan(1).md` (the product's learning requirements, curriculum, data model, architecture, and roadmap).
   - `CODING_STANDARDS(1).md` (mandatory coding, testing, data preservation, and security practices).
   - `Copy of MCPKI_FYP_Starred_Slides_Updated.pptx.pptx` (the 27-slide visual guide and page-specific functional notes).
   - Original robot PNGs/images that I will upload alongside this prompt. Inspect the actual image files before assigning mascots to pages.
2. Read `docs/PROJECT_MEMORY.md` if it exists. It records prior decisions and the next steps. Read `docs/Development_Journal.docx` when needed for human-facing history.
3. Inspect the current repository and tests before changing anything. If code already exists, adapt rather than overwriting it.
4. Extract and review the **visual content, speaker notes, and real PowerPoint comment records** for every slide. Do not read only text boxes or assume a slide image is a complete specification. Use `python-pptx` for speaker notes and inspect OOXML `ppt/comments`, `ppt/commentAuthors`, or modern comment parts if present. If no comments exist, say so; still read all notes. Do not confuse template footer text in notes with real implementation requirements.
5. Create/update `docs/SLIDE_REQUIREMENTS.md`: slide number, visible design, actual speaker notes, any actual comments, intended screen/flow, implementation decision, and deferred/unclear items. Avoid pasting private sample credentials from slide artwork.
6. Produce a concise **source reconciliation, phased implementation plan, and initial project file tree**. Then implement only the first small, working, testable vertical slice. Do not generate 27 disconnected mock screens in one pass.

If a required source file or mascot is missing, record it as a blocker. Use a transparent, clearly labeled placeholder only where necessary; **never invent a replacement mascot**.

## 1. Authority and handling conflicts

Use this interpretation hierarchy:

1. My latest explicit instructions, especially the decisions in this prompt.
2. The Master Plan for product goals, learning science, architecture, and intended behavior.
3. Coding Standards for implementation quality, data integrity, security, and testing.
4. PowerPoint **notes and actual comments** for screen-specific corrections and interactions.
5. PowerPoint slide images for visual structure, hierarchy, typography, page content, and mood.

If they conflict, resolve safely, log the conflict and chosen resolution in `docs/PROJECT_MEMORY.md`, and request my input **only for a consequential product/architecture decision that cannot be resolved by the rules above**. A slide's placeholder numbers, repeated rows, arbitrary example data, or fake sign-in credentials must never become production data. The PowerPoint is a **design storyboard**, not a database, a pixel-perfect UI requirement, or a source of verified content.

### Known reconciliations already decided

- **Technology:** Use the Master Plan's **Flutter + Dart**, **Riverpod**, and **SQLite + Drift**. Windows desktop first; design so Android can follow. The app is local-first and core learning must work offline. Do not switch to React/Flask or add a web backend without asking.
- **Profiles vs login:** Slide 1's notes request sign-in plus sign-up so a person can start learning again with a new account; the Master Plan avoids mandatory cloud login. For the initial MVP implement **Create Local Profile / Choose Profile / Continue** (and separate progress per profile), not fake password authentication. Reserve real cloud accounts and Supabase for later. Never copy the username/password illustrated on slide 1 into the app.
- **Top-level Practice vs vocabulary practice:** Slide 17 describes the **Vocabulary → Review/Practice stack**, which IS designed and should be implemented. The separate **Practice** destination in the primary navigation is NOT yet designed and should remain a clearly labeled, nonfunctional future destination. Likewise, the top-level **Speaking** section is NOT designed; do not invent a detailed screen or AI/voice chat UI now.
- **Immersion:** The product plan includes language acquisition/immersion, but the PowerPoint does not supply its final design. Preserve it in the backlog/architecture without guessing a finished UI.
- **Mastery failure:** Slide 18 says a failed mastery test sends the word back to practice. Implement this as the Master Plan's **Relearning/Review**, keeping every historical attempt and scheduling an appropriate new review; never erase the learner's progress.
- **Significant graphics:** The presentation is deliberately more illustrated than a production UI should be. Reproduce the **vibe, information architecture, card compositions, spacing, colors and polish**, not the full illustration density or pixel positions.
- **Grammar content:** Lesson cards that repeat `是不是` are visual placeholders. Use distinct validated grammar records and prerequisite rules, not a screen filled with copies.

## 2. Product vision

Build a cozy, playful-but-polished, science-informed Mandarin learning companion. The target learner is initially an English-speaking beginner studying **Simplified Chinese with tone-marked Hanyu Pinyin**. The product should teach actual understanding, listening, recall, reading, grammar and independent use; do not equate collecting streaks or clicking a multiple-choice answer with fluency.

The main planned learning areas are:

- **Vocabulary:** New Words → Review/Progression → Mastery, with actual spaced review records.
- **Grammar:** Structured explanation, examples, practice, prerequisites, and scheduled review.
- **Immersion / Language Acquisition:** Later, a curated appropriately leveled reading/listening catalog.
- **Texting / Talking Practice:** Later, an optional AI companion/tutor; voice even later.

The PowerPoint's current primary-navigation visual categories are Home, Vocabulary, Grammar, Practice, and Speaking. Keep the intended design and transparently defer undetailed sections. Do not silently add or remove product areas. Provide sensible route architecture without shipping false functionality.

**Research claims:** implement evidence-informed learning patterns but do not claim the app itself has been scientifically proven effective. The 500/1000/2000/5000 word flags are motivating **product milestones**, not scientifically validated guarantees of survival, communicative skill, or fluency.

## 3. Art direction — IMPORTANT

This app must look like one connected, lovingly designed illustrated world, **not** a generic SaaS admin panel or a gallery of exact PPT screenshots.

### Design identity

- Warm off-white/cream surfaces; deep navy/charcoal for main navigation, buttons and text.
- Soft yellow, sky blue, peach, light green and occasional pink accents; consistent design tokens rather than arbitrary per-screen colors.
- Gentle sunlight, very light cozy study-room hints, subtle borders and shadows, thoughtfully rounded rectangular cards, polished alignment and generous readable spacing.
- Friendly rounded but professional typography (e.g., Nunito/Inter equivalents and a robust Chinese font with tone-mark support). Avoid excessively decorative fonts, heavy glow, 3D gradients or generic artificial-looking components.
- Use a **wide desktop application layout**, targeting approximately 1440×900 / 16:9 as a design reference. Build responsive breakpoints and scrolling for smaller screens; no clipped buttons, squashed text, or giant square/boxy panels.
- Keep interactive controls, Chinese characters and input fields legible. Support keyboard, pointer, focus states, touch later, and accessibility scaling.

### Graphics: restraint on subpages

- The main Home/Vocabulary landing screens may be a little more scenic. Functional subpages should have **simpler, low-distraction backgrounds** with at most a few restrained hints of a sunny room/garden and ample clear space.
- **Do not put the dark navigation sidebar on individual activity/subpages.** Use a clear back button/top header instead. Keep the sidebar on top-level navigation screens where applicable.
- Preserve appealing card compositions from the PPT, not the clutter outside them. Scale backgrounds down aggressively if necessary; never sacrifice form usability to decoration.
- The Mastery screen may feel special with a **subtle evening/night accent** (a small moonlit window or cooler tones), but it must still be an uncluttered rectangular app screen, not a full fantasy illustration.
- Use reusable theme tokens, surface/card/button/input components and consistent layouts. Avoid unnecessary duplicated CTA buttons and decorative noise.

### Original robot mascots are source assets, NOT generation prompts

- Locate and use **my uploaded original robot files directly** as assets, ideally PNGs with transparent backgrounds.
- Do NOT redraw, replace, recolor, animate into a different appearance, invent a pose, modify the mouth, reshape the head, add clothing, alter antennae, change body proportions, or generate a similar-looking character.
- Do not replace one distinct robot with another because it is easier. Record asset paths and mascot assignments in `docs/ASSET_MANIFEST.md`.
- You may resize and position them **without distortion**, but preserve their original artwork and black-outline aesthetic. If background removal is needed, keep the line work unchanged and ask before irreversible edits.
- Use mascots sparingly and meaningfully; they are friendly companions, not content obstructions. Design around the asset rather than changing the character to fit a composition.
- If an image is missing, mark the screen's mascot as pending; do not fabricate art.

## 4. Interpret the PowerPoint as a SCREEN + FLOW SPECIFICATION

On first import, generate `docs/SLIDE_REQUIREMENTS.md` from the real deck, including all notes/comments and these baseline interpretations:

| Slides | Screen / desired behavior |
|---|---|
| 1 | Opening / local profile entry. Notes ask for sign-up as well as sign-in; adapt to separate offline learner profiles during MVP. |
| 2–6 | Click-to-continue introduction about the robots and educational purpose. Include visible next/click hint, progression, and later replay. |
| 7 | Home with word count, streak, weekly progress, fluency milestones, `View Details`, and `Replay Tutorial`. Use real persisted progress, never the sample `570` and `10 days` as fixed values. |
| 8–14 | Interactive tutorial overlays that spotlight real UI components, explain streaks, fluency bar, milestone flags, and navigation. Keep readable forward/back/close actions and replay from the homepage. |
| 15 | Vocabulary landing with Learn, Practice, Master. Slide note specifically asks for a tutorial for Vocabulary and Grammar landing pages, although not pictured. |
| 16 | Learn / Upcoming Words table, Add Your Own Word, Learn a Word. List data is dynamic. Notes require cross-checking possible duplicates by Hanzi/Pinyin/meaning and warning/confirmation rather than silently accepting or losing inputs. Custom-word workflow references slide 25 for user-supplied sentences. |
| 17 | Vocabulary Review/Practice list, relearn by matching supplied Pinyin/Hanzi/meaning, and selected/random/endless quizzes. Handle ambiguous matches safely. This is NOT the undesigned top-level Practice section. |
| 18 | Mastered vocabulary, selected/random/endless harder tests. Failed mastery returns to Relearning/Review with full history retained. Keep book icon rather than a crown; preserve the user's original robot art. |
| 19 | Word introduction: Hanzi + tone-marked Pinyin + meaning + listening + **exactly five checked example sentences**, plus a **Continue to Quiz** button missing from artwork (the notes explicitly correct this). Do not treat slide's six example rows as mandatory. |
| 20 | Multiple-choice word-meaning recall. |
| 21 | Hanzi → Pinyin recognition with distractors; correct Pinyin/tones in validated lesson data. |
| 22 | Pinyin → Hanzi recognition with appropriate distractors. |
| 23 | Audio recognition with four playable choice controls; audio must exist or have an honest unavailable fallback. |
| 24 | Word-order sentence construction. Offer drag/drop and an accessible tap/reorder alternative. Validate allowed sentence order(s) instead of comparing simplistic unnormalized strings. |
| 25 | Five Chinese sentences paired with English translations; substantial productive practice, also referenced by slide 16's custom-word intake. Reuse a shared form component where appropriate, but distinguish the two business workflows and validate input. |
| 26 | Grammar lesson/chapter browser, scrollable, sourced from real distinct grammar records. Notes request a tutorial/replay entry point and forbid repeated fake lessons. |
| 27 | Grammar detail, with `name`, `meaning`, `grammar structure`, `grammar rules`, and `examples` in its data model. The pictured A-not-A lesson is an example, not the entire curriculum. |

The PPT speaker notes may contain extra corrections not captured above; **the extracted notes themselves must be checked as you implement each slide**. Some slides may have legacy template/footer text in their notes; do not treat those as user requirements. The supplied deck currently appears to have speaker notes but no true PowerPoint comment records; independently verify this in the workspace.

## 5. Core learning behavior and data integrity

### Vocabulary engine

- The visible stacks are New Words, Review/Progression and Mastery. Persistent scheduler state and review history live in the database independently of how they are displayed.
- New word presentation includes characters, tone-marked Pinyin, English meaning/sense, pronunciation audio when available, and verified, contextual example sentences.
- Use varied, appropriate checks: meaning, sound, Hanzi/Pinyin match, contextual choice, sentence ordering, and later independent typed output. Not every exercise must be forced into every word session; retain the deck's UI patterns as a design library and sequence them appropriately for level and difficulty.
- Initial successful learning moves an item toward Review. An early follow-up may be due ~5 minutes later as a **configurable** learning step, not an untested universal law. Later reviews are adaptive; evaluate/test a maintained Dart FSRS package before adopting it.
- Graduation requires spaced, delayed, varied and independent retrieval evidence, not five quick correct clicks. Distinguish recognition from production and hint-assisted answers.
- Failed mastery creates a new Relearning/Review schedule without deleting previous history; avoid harsh punitive UX.
- Selected/random/endless tests have actual item-selection and stopping logic. Do not ship nonfunctional buttons.
- A custom word may have multiple pronunciations/senses and similar translations. Duplicate checks by Hanzi/Pinyin/meaning should provide **possible-match warnings and a human choice**, not naively ban legitimate variants. Store stable IDs and source/provenance.
- For the five-pair custom-word form, validate entries. User-submitted examples are unverified drafts until reviewed; never silently generate/publish canonical curriculum or guarantee valid answer questions from arbitrary sentences.

### Grammar

- Foundational grammar begins early, not only after a raw vocabulary threshold. Progression follows prior grammar patterns and familiarity with example vocabulary.
- Each stored pattern has identity, explanation, structure, rules, verified examples, prerequisites, and its own review progress.
- Use the A-not-A example (`A + 不 + A`, including `是不是`, `对不对`, `喜不喜欢`) and the special `有没有` form as a starter only. Validate Chinese, romanization, translations and acceptable variants before release.
- Grammar lessons should support explanation → worked examples → short comprehension/arrangement/output → feedback → later review, built incrementally.

### Onboarding, progress and tutorial

- New learner chooses a local profile, level/goal, and suitable basic settings. A tiny Foundation introduction explains Hanzi, Pinyin, tones, and first sentences. No cloud account or paid API required.
- Dashboard shows real counts and due items, and a reasonably achievable daily mission based on available work. Do not invent fake achievements or incorrectly treat milestone word counts as a measured fluency score.
- Tutorial uses contextual step-by-step overlays and a Replay Tutorial control. Preserve meaningful labels and flag explanations, but avoid false educational guarantees.

### Content and audio

- Start with a **small set of verified fixtures**; later consider importing the Master Plan's chosen sources: HearMandarin HSK 3.0 Word List for vocabulary, HSK Sentences Audio for contextual sentences/audio. Check actual availability, licenses, attribution, tone accuracy, source metadata, and usable file sizes before import. Word audio is **not** automatically included with HearMandarin.
- No invented or randomly generated bulk Chinese dataset. Maintain content revisions separately from per-learner state. No AI API should be required for fixed-answer exercises.
- Audio playback must be genuinely wired to lawful files or supported TTS, not simulated by a button icon; handle missing audio with clear UI and tests.

## 6. Application architecture — keep it modest

Use the Master Plan's initial stack: **Flutter + Dart + Riverpod + SQLite/Drift**. Windows-first; Android later. No mandatory web server, cloud account, analytics, subscriptions, paid provider, or AI key in the MVP.

Use a sensible feature-first structure, for example:

```text
lib/
  app/                  # startup, routing, theme and app shell
  core/                 # errors, secure helpers, time abstraction
  data/                 # Drift DB, schema, migrations, verified content import
  features/
    profiles/
    onboarding/
    dashboard/
    vocabulary/
    review/
    grammar/
    immersion/           # architecture/backlog only, not a fabricated final UI
    practice_hub/        # defer design/implementation
    conversation/        # defer speaking and AI screens
  shared/               # design system, validated shared widgets/models
assets/
  mascots/               # my original art
  illustrations/         # only approved licensed assets
  content/               # approved offline learning fixtures
scripts/
  ...
test/
integration_test/
docs/
  PROJECT_MEMORY.md
  Development_Journal.docx
  SLIDE_REQUIREMENTS.md
  ASSET_MANIFEST.md
  DESIGN_SYSTEM.md
  DECISION_LOG.md
```

The folders are guidance, not a reason to create dozens of empty files. Separate rendering, domain rules, validation, and storage. Use shared models and tested components; avoid duplicate grading, review scheduling, word lookup, Pinyin formatting, and database logic. Database owns persisted state; services/domain rules own transitions; widgets do not write raw SQL. Inject the clock for deterministic time-based tests.

## 7. Coding rules — non-negotiable

Follow `CODING_STANDARDS(1).md` in full. In particular:

- Inspect existing code before editing; **DRY without overengineering**.
- Work one vertical slice at a time. Every change should be minimal, explainable and testable.
- Add/update unit tests for behavior, widget tests for meaningful UI states, database/migration tests for persistence, regression tests for every substantive bug, and milestone integration tests.
- Before claiming a task is done, run `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, and `flutter test` where tools are available. Report **PASS / FAIL / NOT RUN with reason** honestly; run relevant integration tests when supported.
- Treat user input, imported data, AI output, URLs, asset paths, and remote data as untrusted. Use Drift typed or parameterized SQL queries; validate import paths and Unicode; avoid hardcoded secrets.
- Never overwrite/drop the learner database to make development easy. Use tested migrations, transactional review updates, stable IDs, and immutable/deduplicated review events.
- Core study, grading, scheduling, and progress saving must function offline. External AI/cloud services are optional later integrations.
- Respect dataset/audio licenses and attribution. Never ship an arbitrary PowerPoint screenshot as app UI or reproduce protected graphics as if they were licensed standalone assets.
- Handle loading, empty, no-due-reviews, unavailable audio, offline, invalid-data, accessibility and small-window states honestly.

## 8. Persistent multi-session memory — required DOCX + Markdown

**This is critical. You must not start from scratch in each VS Code/Codex session.** Keep two synchronized project-memory artifacts:

1. `docs/PROJECT_MEMORY.md` — the **canonical machine-readable state** that the coding assistant reads at the start of every session.
2. `docs/Development_Journal.docx` — a **human-readable Microsoft Word mirror** of the same current plan, decisions, progress, next steps and test status. Use `scripts/sync_journal.py` (supplied separately) or `python-docx` to regenerate it after the Markdown is updated. The `.docx` is a journal, not the product database or the sole place where requirements live.

Create these files at project bootstrap if absent. If they exist, **merge/append; do not discard history**. Keep headings and entries concise, current and actionable. Include:

- Project vision and essential invariants (including Flutter/local-first, untouched robots, uncluttered subpages, defer top-level Practice/Speaking).
- Sources read, including PPT slide numbers and actual speaker note/comment decisions.
- Current phase and implementation status; what is actually working vs placeholder.
- Architecture and UI decisions, date, reason and affected files.
- Active feature/task, blocker(s), assumptions and open questions.
- Completed work with filenames/commit IDs when available.
- Tests **actually executed** with results, plus unrun checks and reasons.
- Prioritized backlog and **the next three concrete tasks**, with acceptance criteria.
- Known risks, limitations, and user approval needed for consequential changes.

**Session ritual:**

- **At session start:** read the two Markdown source specifications, `docs/PROJECT_MEMORY.md`, the relevant PPT slides/notes/comments, and affected source/tests. Announce a short task plan.
- **Before significant changes:** record a decision/risk in Markdown. For a change to existing architecture or learner data, request approval and create a recovery path.
- **After every completed slice, discovered blocker, or changed plan:** update `docs/PROJECT_MEMORY.md`, then regenerate the Word journal. Record actual verification, not guesses. Commit both if they are part of version control.
- **At session end:** summarize what changed, exact test results, limitations, and the next three steps; ensure journal is synchronized. If Word generation tools are unavailable, still update Markdown immediately, explicitly flag Word sync as pending, and never claim it was updated.
- Do not let the journals grow into unsearchable transcript dumps: use a concise current-state summary + dated decision/work log. Archive old detailed notes only when useful, never delete meaningful decisions.

The supplied starter `docs/PROJECT_MEMORY.md`, `docs/Development_Journal.docx`, and `scripts/sync_journal.py` may be copied into the repo. Run `python scripts/sync_journal.py` after edits to the Markdown; install `python-docx` for this development-only script if needed.

## 9. Implementation priority and scope protection

**First** inspect/reconcile the repo and sources, generate slide requirements and mascot inventory, document the design tokens, and create the two memory files.

Then deliver in small, tested increments:

**Phase A — foundation and first genuine user journey**
1. Initialize/inspect Flutter app, Riverpod, Drift, navigation and a reusable design system; create/select an offline local learner profile.
2. Build a coherent Home/Vocabulary shell and a modest first-run onboarding/tutorial path using the PPT's vibe, not its heavy background graphics.
3. Add a tiny verified local lesson content pack, storage, one Learn → Quiz → Review scheduling flow, restart persistence and tests. Ensure UI states are fed by actual repositories, not decorative hard-coded counters.

**Phase B — vocabulary completeness and grammar basics**
4. Build all three visible vocabulary stacks, word-detail screen, meaningful multiple-choice/audio/Hanzi/Pinyin and sentence ordering interactions, custom word intake/duplicate warnings, selected/random/endless modes and truthful mastery logic.
5. Build grammar browsing/detail for real distinct patterns, early foundational lessons and review records. Add grammar tutorial entry points.
6. Introduce curated data import/versioning, licenses, and stronger integration tests; expand content only when quality checks pass.

**Later, NOT NOW**
- Full top-level Practice UI (not currently designed).
- Full top-level Speaking UI, texting/talking/AI integration, or real-time voice.
- Full Immersion catalog UI (planned but not fully designed in the deck).
- Cloud profiles/login, Supabase sync, subscription/payment systems, massive bulk imports, complicated mascot animation.

It is acceptable for deferred top-level navigation destinations to show a tasteful **"Coming later — design pending"** state; do not pretend there are working lesson features there. Keep these placeholders out of mastery scoring and other product metrics.

## 10. Deliverables for your FIRST response/task in this VS Code workspace

1. Confirm exactly which source files, PPT slides, note bodies, comments and mascot assets you successfully read. If there are no actual PPT comment parts, say that explicitly.
2. Create `docs/SLIDE_REQUIREMENTS.md`, `docs/ASSET_MANIFEST.md`, `docs/DESIGN_SYSTEM.md`, `docs/PROJECT_MEMORY.md` and its synced `docs/Development_Journal.docx` (using the existing starter files where provided).
3. Summarize any requirement conflicts (especially local profiles vs slide 1 sign-in; vocabulary practice vs undesigned main Practice; mastery failure behavior) and log their decisions.
4. Show a compact, sensible folder structure and a prioritized, feasible roadmap. **Do not** immediately build the entire app or import thousands of unverified words.
5. If Flutter tooling and an existing repo are ready, start **one small end-to-end working slice** and test it. Otherwise set up only the minimal skeleton and tell me exactly what to run next.
6. End with this honest completion format:

```text
Implemented:
- ...
Files changed:
- ...
Tests/checks actually executed:
- dart format: PASS / FAIL / NOT RUN (reason)
- flutter analyze: PASS / FAIL / NOT RUN (reason)
- flutter test: PASS / FAIL / NOT RUN (reason)
- Relevant integration/manual checks: PASS / FAIL / NOT RUN (reason)
Security/data-integrity review:
- ...
Source/design decisions:
- ...
Journal synced? Markdown: YES/NO; Word: YES/NO (reason)
Known limitations:
- ...
Next three tasks:
1. ...
2. ...
3. ...
```

**Bottom line:** Act like a careful, long-term engineering partner. Build a unified, consistent app based on the *intent* of the PowerPoint and the actual written specifications. Preserve my original robots, prioritize usable rectangular layouts and clean subpages, implement real offline learning behavior rather than cosmetic mockups, and always leave updated, accurate project memory for your next session.
