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
