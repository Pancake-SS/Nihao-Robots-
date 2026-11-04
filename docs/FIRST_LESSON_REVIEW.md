# First vocabulary lesson — review brief

Prepared 2026-11-04. Status: preparation only; no approved lesson pack or new runtime content.

## Smallest useful scope

Begin with one sense of one word, five checked examples, a meaning-recall check and an early scheduled review. Candidate: the greeting `你好`, already fact-checked for orientation in `FOUNDATION_CONTENT.md`. Its appearance in the introduction does not make it approved scored curriculum. Confirm the candidate and its examples during content review before implementing the pack.

Use a stable sense ID such as `starter.greeting.nihao.1` and a separate content revision. Correcting text must not change the sense ID or detach review history. Do not bind progress to display text or list position.

## Required review record

| Field | Acceptance requirement | Current state |
|---|---|---|
| Sense and usage | One clear greeting sense; explain context and register | Candidate only |
| Hanzi and Pinyin | Simplified characters; tone-marked Pinyin; documented word segmentation and tone-change conventions | Orientation references available; lesson review pending |
| Five examples | Exactly five natural, contextual Chinese examples, each with checked Pinyin and English meaning | Not authored or approved |
| Content provenance | Author/source, exact reference, reuse permission/license and revision per imported record | Pending |
| Language review | Named reviewer or clearly recorded review method/date; unresolved concerns remain visible | Pending |
| Audio | Lawful file, attribution, matching transcript and playback verification, or explicit absence | No audio selected |
| Quiz | Unambiguous correct answer, plausible distinct distractors and reviewed feedback | Pending |

For the five examples, seek useful variation rather than repeated substitutions: greeting a new acquaintance, introducing oneself, addressing a teacher, opening a brief service interaction, and beginning a short dialogue. These are editorial prompts, not claims that any unwritten sentence is correct. Keep supporting vocabulary explained so the first lesson does not test untaught material.

## Implementation acceptance after review

1. Store versioned content separately from learner state. Reject malformed packs, duplicate IDs, missing required fields and example counts other than five before writing anything.
2. Present characters, optional Pinyin, meaning and exactly five examples, followed by Continue to Quiz. Missing audio must not block the non-audio activity or display a fake play button.
3. Keep first-session checks modest. Passing recognition enters learning/review; it does not grant mastery. Avoid forcing every storyboard exercise into a single greeting lesson.
4. Save an attempt with a unique event ID and the next review state in one transaction. Retrying the same submission must not duplicate attempts or rewards. Keep incorrect attempts.
5. Test a configurable early due interval with an injected clock: unavailable immediately before due, available at due, retained across restart. Do not select an FSRS package or invent long-term scheduling rules during this preparation pass.
6. Verify profile isolation, failed-write recovery, duplicate submission and complete Learn → Quiz → Review → restart behavior before expanding the pack.

No new dataset, license, audio permission, native-speaker approval or scheduler compatibility is claimed by this document.

## Structural parser implemented (2026-11-04)

`lib/features/vocabulary/content_pack.dart` now parses bounded JSON into immutable records. It has no database, network or file-write side effects and is not yet connected to the landing page or an importer. An `approved` string is a declaration requiring curator verification, never proof of review or licensing. Text checks do not establish correct Hanzi, tone marks, translation or teaching quality.

The v1 envelope requires exactly `schemaVersion` (integer 1), `id`, `revision` (positive 32-bit integer), and `words` (1–50 entries). Input is limited to 1,000,000 UTF-16 code units. IDs use lowercase letters/digits with single dot, underscore or hyphen separators, at most 100 characters. Repeated word IDs are rejected; different sense IDs may share Hanzi.

Each word requires exactly `id`, `hanzi`, `pinyin`, `meaning`, `examples`, `source`, `license`, `reviewedBy`, `reviewedOn`, `reviewStatus`, and `audio`. The source/license/review declaration must cover the whole word record including its examples; combine precise citations if several sources are used. Review status must be `approved`, the date must be a real `YYYY-MM-DD` date, and audio must be explicitly null until audio import is implemented. All required text is nonblank and bounded; controls and hidden direction markers are rejected.

Examples require exactly `hanzi`, `pinyin`, and `meaning`. There must be exactly five, with distinct Hanzi strings after trimming. This catches exact repetition, not paraphrases or every Unicode-equivalent duplicate. Unknown fields fail instead of being silently ignored. Unsupported schema versions fail explicitly. No real pack is bundled. Five parser tests use synthetic, non-curriculum data; the complete 38-test suite passes.
