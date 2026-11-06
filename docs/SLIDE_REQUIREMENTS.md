# Slide requirements and source reconciliation

## Implementation checkpoint — 2026-11-06

Slides 20–22 now have code-generated meaning, Hanzi→Pinyin and Pinyin→Hanzi questions, plus reverse meaning/Pinyin directions. Slide 19 has five examples and offline sentence controls for 20 imported lessons; standalone word audio remains unavailable. The 21 published lessons each have eight questions. Translated cloze and single-word typed recall are additional patterns, not completion of slide 24's ordering or slide 25's five-sentence production form. Slide 23's audio-choice quiz remains pending. Original slide/notes audit below is retained.

Audit date: 2026-11-03 (Asia/Kuala_Lumpur). Source: `reference/Copy of MCPKI_FYP_Starred_Slides_Updated.pptx.pptx`.

## Pilot implementation update — 2026-11-04

Slide 19 now has a real five-example greeting lesson and Continue to Quiz route. Slide 20's meaning recognition is implemented with four choices, deterministic grading and saved feedback. A second meaning → Hanzi question uses the shared choice UI; it does **not** implement slide 22's Pinyin → Hanzi task. Slides 21–25's remaining exercise families are pending. The pilot is explicitly source-checked with independent teacher review pending; see `STARTER_GREETING_REVIEW.md`.

Slide 17 is partially implemented as a per-profile due-review list with real counts, due dates, failure/relearning and preserved attempts. Selected/random/endless batches, search/manual movement and a readable history UI remain pending. Slide 18's Master and graduation are not implemented; the five-minute/one-day pilot policy awards no mastery. Main Practice/Speaking remain design-pending. Subpages use a calm back-header layout with no sidebar or repeated robot; the six existing original artwork copies are unchanged.

## Evidence and audit scope

- Read both complete source specifications, the master implementation prompt and `reference/POWERPOINT_SPEAKER_NOTES.md`; the convenience extraction was checked against the real deck rather than trusted by itself.
- Independently opened all **27 slides** with `python-pptx` and examined their linked notes; **17 notes parts**, including empty/template-only bodies. The deck is 16:9, 18,288,000 × 10,287,000 EMU.
- Inspected ZIP entries plus relationship and content-type references for classic/modern comments, comment authors and persons: **0 comment/author parts and 0 related references**. No actual PowerPoint comments exist in this source. Speaker notes are not comments.
- Rendered all 27 slides with installed Microsoft PowerPoint using a read-only, hidden presentation, without saving the source. Inspected all rendered/embedded source artwork; slides2–6 and8 were checked as full composites because native shapes add content beyond the embedded images. Temporary previews are under `%TEMP%/nihao-slide-render/`; they are review aids, never app assets. Preview contact sheet1 redacts the source sign-in sample values only.
- The linked notes-part number is **not** the slide number: e.g. slide7 uses `notesSlide3.xml`. `scripts/audit_presentation.py` follows actual relationships via `python-pptx` and records all body/placeholder text without re-saving the deck. It also checks comment-related relationship/content-type references.
- Deck SHA-256: `0203524e371afdbd427f396fd30bcdab813230be3a485a0441d083bcf7f8e73d`.
- Notes below preserve actual spelling and punctuation; paragraph runs are joined by `python-pptx`. A missing notes part is distinguished from an empty body. The repeated `1.7.2013`, `4`, and `‹#›` tokens are legacy template/date/page material, not functional requirements. Date/page placeholders outside the note body are likewise excluded from requirements.
- Requirement status: this document is the reconciled implementation backlog. It does **not** claim that these screens or learning features are implemented.

## Decisions that apply across slides

1. Latest user decisions and Master Plan override storyboard literals. Flutter/Dart, Riverpod and Drift/SQLite remain the chosen native local-first architecture.
2. Local profiles replace slide1's password login; profile creation enables a fresh learning history without deleting another profile's data.
3. Vocabulary Review/Practice (17) is designed. The separate main Practice and Speaking destinations remain **Coming later — design pending**; Immersion stays in the backlog.
4. Mastery failure schedules Relearning/Review while preserving history; initial recognition and quick repetitions do not prove mastery.
5. Exactly five checked examples plus Continue to Quiz override slide19's six rows/missing CTA. Repeated words and grammar lessons, sample counters and progress fractions are artwork placeholders, never production records.
6. Preserve navigation, hierarchy, cream/navy/pastel palette and card compositions; reduce illustrated background density. Functional subpages use back/header navigation, with no dark sidebar.
7. Use the uploaded original robot images directly. Match white-line/dark-surface or black-line/light-surface files by inspected asset identity; use varied characters with stable roles. Never copy a robot pose/redraw from the deck merely because it differs from the original. See `ASSET_MANIFEST.md`.
8. Introductory scientific/competitive assertions and milestone fluency guarantees are rewritten as modest learning-method/product-milestone explanations. Streaks count qualifying days, not words (correcting slide8's visible wording).
9. Validated content and audio rights are prerequisites for learning release. Pinyin, example translations and grammar text in slide artwork are not independently approved curriculum.

## Per-slide record

Implementation update, 2026-11-04: slides 2–6 now inform the five-page purpose introduction, followed by four Foundation pages with per-profile save/resume/replay. Home navigation and milestone explanations (7), live contextual tours (8–14), Vocabulary's three landing cards/tutorial (15) and a pending-content Grammar landing/tutorial (26) exist. Word metrics, weekly/streak data, vocabulary activities and grammar lessons remain deferred; no placeholder values or exercises were shipped. The audit records below preserve the original source reconciliation rather than claiming all storyboard requirements are complete. Native Windows verification is still pending.


### Slide 01 — Opening / local profile entry

**Visible design:** Split composition: deep navy evening study scene and large brand title on the left; warm cream area with a white form card and peach backing on the right. Multiple robot companions sit around the form. The artwork depicts a username/password sign-in, an administrator label and presentation-specific action. Private sample values are intentionally omitted here.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide1.xml):

> I want a simple log in page. The example given here doesn’t include a sign up option so include it. I just wanted to make accounts so that it is easier to relearn from the start by making new accounts. Also to help the opening with the ni hao robots.

**Other note placeholders / excluded material:** `1`

**Actual comments:** None.

**Intended screen / flow:** App launch → Create Local Profile / Choose Profile → Continue → first-run introduction or Home.

**Implementation decision:** Use offline profile identity and separate learner progress; never implement decorative password authentication or administrator/server copy. Preserve warm/dark contrast, readable form labels and restrained original artwork. Replace the illustrated non-original hero robot with an untouched supplied asset; select variants by the actual surface color.

**Deferred / unclear:** Profile persistence, Unicode-safe name validation, level/goal/settings and existing-profile recovery are the first vertical slice. Cloud authentication and Supabase are later.


### Slide 02 — Introduction 1 / robot greeting

**Visible design:** Dark navy study-room scene with a moonlit window, lit desk, rounded central outlined message panel and a lineup of nine distinct white-outline robots. Large white greeting says 你好! and introduces the Ni Hao robots.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide2.xml):

> From slide 2 to 6 is going to be a sort of introductionary scene that talks to the user about the application and its main purpose. Make it continue from text to text using a click and include a little message to indicate click to continue.

**Other note placeholders / excluded material:** `2`

**Actual comments:** None.

**Intended screen / flow:** First-run introduction step 1 of 5 → next/back/skip → Foundation/Home; replay later.

**Implementation decision:** Create one reusable introduction component with explicit Click to continue / Next, keyboard activation, progress, back and close/skip. Use original dark-surface variants, fewer characters per view and no automatic animation dependency.

**Deferred / unclear:** Full introductory sequence and replay require persisted per-profile onboarding state; the source has no explicit click hint despite its note.


### Slide 03 — Introduction 2 / product purpose

**Visible design:** Same dark room, message card and robot lineup as slide 2; centered paragraph describes standing apart in a crowded language-learning landscape.

**Actual speaker-note body** (no linked notes part):

_No notes part; no speaker-note body._

**Other note placeholders / excluded material:** None.

**Actual comments:** None.

**Intended screen / flow:** Introduction step 2 of 5.

**Implementation decision:** Retain the purpose and companion tone in short, clear copy explaining what the learner will do. Share layout and navigation with slide 2.

**Deferred / unclear:** Final copy should communicate concrete learning benefits without competitive marketing claims.


### Slide 04 — Introduction 3 / understanding over points

**Visible design:** Same evening message panel and nine-robot lineup. Visible copy criticizes language-learning apps as games intended to make people spend.

**Actual speaker-note body** (no linked notes part):

_No notes part; no speaker-note body._

**Other note placeholders / excluded material:** None.

**Actual comments:** None.

**Intended screen / flow:** Introduction step 3 of 5.

**Implementation decision:** Use the higher-priority Master Plan to explain recall, understanding and meaningful use positively. Do not ship the unsubstantiated broad accusation about other apps. Keep navigation and progress visible.

**Deferred / unclear:** Final approved product copy; no monetization claims or new subscription features.


### Slide 05 — Introduction 4 / learning approach

**Visible design:** Same room and panel; a long large white paragraph claims techniques based on scientific neural research will benefit Chinese learning. The text nearly fills the panel.

**Actual speaker-note body** (no linked notes part):

_No notes part; no speaker-note body._

**Other note placeholders / excluded material:** None.

**Actual comments:** None.

**Intended screen / flow:** Introduction step 4 of 5.

**Implementation decision:** Shorten to evidence-informed patterns: spaced review, retrieval, context and feedback. Do not claim this app is scientifically proven. Prioritize readable text at accessibility scales over the deck text size.

**Deferred / unclear:** Learning-effectiveness evaluation is later; no proof or fluency guarantee in onboarding.


### Slide 06 — Introduction 5 / start learning

**Visible design:** Same dark panel and robot lineup with a shorter invitation to begin learning Chinese.

**Actual speaker-note body** (no linked notes part):

_No notes part; no speaker-note body._

**Other note placeholders / excluded material:** None.

**Actual comments:** None.

**Intended screen / flow:** Introduction step 5 of 5 → Foundation introduction / Home; store completion per profile.

**Implementation decision:** Provide an explicit final Start learning action, back and replay path. Introduce Hanzi, Pinyin, tones and first sentences in a small Foundation flow rather than immediately testing unexplained concepts.

**Deferred / unclear:** Foundation content/audio verification and persisted completion are subsequent work.


### Slide 07 — Home / real progress dashboard

**Visible design:** Sunny study room with dark left navigation: Home, Vocabulary, Grammar, Practice, Speaking. Home title and Replay Tutorial above two cards for total words and streak. Weekly activity strip sits above a scenic milestone path with four flags and View Details. Hover-saucer, orb-head, goggles and tall-thin robots appear in distinct roles. Counts in the artwork are illustrative.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide3.xml):

> This is the home page and the slides from 7 to 14 will focus purely on how I want the tutorial system to work. I also didn’t mention it but the view details is going to show more clearly on what the flags mean and do a sort of highlight of what words were learned for each flag.

**Other note placeholders / excluded material:** `7`

**Actual comments:** None.

**Intended screen / flow:** Home → Vocabulary or Grammar; Replay Tutorial → slides 8–14; View Details → milestone explanation and related learned words.

**Implementation decision:** Render learned/review/mastery counts, streaks, weekly activity and due work from repositories. Rename fluency progression to learning/word milestones or label it explicitly as product milestones. View Details must explain thresholds and list relevant real words. Maintain primary navigation order and mark undesigned destinations honestly.

**Deferred / unclear:** No fake achievements or counts. A new learner needs an achievable mission even with no mastery or grammar reviews due. Immersion remains planned without a guessed finished screen.


### Slide 08 — Home tutorial / streak and week

**Visible design:** Dimmed dashboard with a cream explanatory callout, yellow outline around streak and weekly activity, and a curved arrow. A native peach circular next arrow is also present in the rendered slide. The visible explanation incorrectly conflates word count with the streak.

**Actual speaker-note body** (no linked notes part):

_No notes part; no speaker-note body._

**Other note placeholders / excluded material:** None.

**Actual comments:** None.

**Intended screen / flow:** Tutorial step explaining real streak/weekly controls → next/back/close.

**Implementation decision:** Spotlight live widgets, not screenshot coordinates. Explain consecutive qualifying local calendar days separately from learned-word count. Provide focus containment, keyboard actions, step count, readable controls and safe placement on narrow windows.

**Deferred / unclear:** Define qualifying daily activity and timezone behavior with an injected clock and persisted events; no hardcoded weekday ticks.


### Slide 09 — Home tutorial / milestone bar

**Visible design:** Dimmed dashboard with bottom milestone path highlighted and a cream callout describing the bar as Chinese fluency based on words learned.

**Actual speaker-note body** (no linked notes part):

_No notes part; no speaker-note body._

**Other note placeholders / excluded material:** None.

**Actual comments:** None.

**Intended screen / flow:** Tutorial milestone overview → individual flag steps.

**Implementation decision:** Keep the path and explanatory interaction but label it a motivating vocabulary milestone, not measured fluency. Explain that comprehension and production need separate evidence.

**Deferred / unclear:** Exact progress-count definition must be tied to stable learner/item records; decorative path position is not knowledge state.


### Slide 10 — Home tutorial / 500-word flag

**Visible design:** First red flag and beginner segment highlighted; callout claims 500 learned words are enough for survival tasks such as greetings/food.

**Actual speaker-note body** (no linked notes part):

_No notes part; no speaker-note body._

**Other note placeholders / excluded material:** None.

**Actual comments:** None.

**Intended screen / flow:** Tutorial first flag; also available from View Details.

**Implementation decision:** Keep 500 as a product milestone. Replace the survival guarantee with a neutral explanation of the collection milestone and possible practice themes. Include text labels so color is not the sole cue.

**Deferred / unclear:** No verified skill qualification follows automatically from word count.


### Slide 11 — Home tutorial / 1,000-word flag

**Visible design:** Green flag and elementary segment highlighted; callout ties 1,000 words to basic general-topic communication.

**Actual speaker-note body** (no linked notes part):

_No notes part; no speaker-note body._

**Other note placeholders / excluded material:** None.

**Actual comments:** None.

**Intended screen / flow:** Tutorial second flag; milestone details.

**Implementation decision:** Keep 1,000 as a motivating target, use neutral milestone copy and link to actual learner words. Do not assert communicative ability solely from the count.

**Deferred / unclear:** No formal level certification or external proficiency equivalence.


### Slide 12 — Home tutorial / 2,000-word flag

**Visible design:** Blue flag and intermediate segment highlighted; callout claims longer, deeper conversations and giving opinions.

**Actual speaker-note body** (no linked notes part):

_No notes part; no speaker-note body._

**Other note placeholders / excluded material:** None.

**Actual comments:** None.

**Intended screen / flow:** Tutorial third flag; milestone details.

**Implementation decision:** Keep 2,000 as a product milestone. Explain further practice opportunities without promising conversational depth. Reuse the contextual overlay component.

**Deferred / unclear:** Content recommendations can follow later, based on verified content and learner evidence.


### Slide 13 — Home tutorial / 5,000-word flag

**Visible design:** Final pink/red flag and advanced segment highlighted near the tall thin robot. The callout equates 5,000 words with fluency and smooth conversation.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide4.xml):

_Notes part exists, but its body is empty._

**Other note placeholders / excluded material:** `13`

**Actual comments:** None.

**Intended screen / flow:** Tutorial fourth flag; milestone details.

**Implementation decision:** Keep 5,000 as a product milestone and remove the fluency guarantee. Preserve history and distinguish recognized, reviewed and independently recalled vocabulary.

**Deferred / unclear:** The slide has a notes part but its body is empty; a slide-number placeholder is not an implementation note.


### Slide 14 — Home tutorial / primary navigation

**Visible design:** Whole dark left navigation highlighted, with callout and arrow explaining movement between app sections.

**Actual speaker-note body** (no linked notes part):

_No notes part; no speaker-note body._

**Other note placeholders / excluded material:** None.

**Actual comments:** None.

**Intended screen / flow:** Final Home tutorial step → close and resume Home.

**Implementation decision:** Explain Home, Vocabulary and Grammar. Practice and Speaking retain visible Coming later — design pending states and contribute no scores. Vocabulary Practice is a separate nested route. Replay never resets progress.

**Deferred / unclear:** Undesigned top-level Practice, Speaking and Immersion UI remain out of this slice.


### Slide 15 — Vocabulary landing

**Visible design:** Sunny room, dark sidebar and a Replay Tutorial control. Three large rounded cards in yellow, blue and green: Learn, Practice, Master. Each card has heading, short text, a distinct robot and one wide CTA. Learn uses hover-saucer, Practice orb-head, Master goggles.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide5.xml):

> I didn’t include tutorials for this page or the grammar page but don’t forget to make it.
>
> 4
>
> ‹#›

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›` Body trailing `4` and `‹#›` are also template material; only the tutorial sentence is substantive.

**Actual comments:** None.

**Intended screen / flow:** Vocabulary → Learn/New Words (16), Review/Practice (17), Mastered Words (18).

**Implementation decision:** Use a reusable landing-card composition and provide the requested Vocabulary tutorial. Keep all three stacks separate from scheduler state. Use original robot poses; do not reproduce added books, modified limbs or other alterations in illustrated assets.

**Deferred / unclear:** Cards may be delivered incrementally; do not wire a CTA to an inert mock lesson. Grammar also requires tutorial support by this note.


### Slide 16 — Vocabulary Learn / upcoming list and custom intake

**Visible design:** No sidebar; large Learn header and round back button. Left sky-blue Upcoming Words table has Pinyin/Hanzi/Meaning columns. Upper-right yellow custom-word card has three labeled fields and Next; lower-right blue Learn a word CTA card. Source rows repeat and omit tone marks.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide6.xml):

> Here the words re peat but for the real app it should be depending on the different word lists that will be made. The add your own words section will go to slide 25 where the user has to give examples to give enough information for the word to be added to the list and for making the questions for that word. There should be a check to see if the word is a repeat from the existing word list either by the hanzi, pinyin, or meaning. In that case cancel the word addition and prompt the user if they still want to add the word with a warning.

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›`

**Actual comments:** None.

**Intended screen / flow:** Learn → select upcoming word → introduction (19); custom fields → possible-match review → five example/translation pairs (25 shared form) → save draft.

**Implementation decision:** Use real word/sense records and tone-marked Pinyin. Check possible matches across Hanzi, normalized Pinyin and meaning without silently discarding input. Show candidate senses/pronunciations and let the learner cancel or explicitly add a legitimate variant. Keep custom examples unverified drafts with provenance; arbitrary sentences cannot automatically create canonical questions.

**Deferred / unclear:** Duplicate matching, form validation, example review and import licenses need tests. Do not interpret cancel in the note as deleting the learner draft. Use only restrained toaster/orb/hover-saucer art.


### Slide 17 — Vocabulary Review / Practice

**Visible design:** No sidebar; Practice header and back button. Left blue word table, upper-right yellow Relearn card accepting Pinyin, Hanzi or Meaning, lower-right selected/random/endless quiz actions. Toaster, orb and tracked robots occupy supporting positions.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide7.xml):

> The only thing of note here is that the relearn will use one of the following pinying, hanzi, or meaning and checks the list if there is a matching one. If there is send it back to the learning word list.

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›`

**Actual comments:** None.

**Intended screen / flow:** Vocabulary → Review; lookup → explicit matching item/sense → relearn; selected/random/endless modes → quiz session.

**Implementation decision:** This is the designed vocabulary review stack, not the undesigned main Practice destination. Resolve ambiguous matches with a candidate list and confirmation; do not move every similar translation automatically. Relearning presents the word again while retaining immutable attempts and schedule history. Define actual selected/random/endless selection and stopping rules.

**Deferred / unclear:** Empty list, no due items, no matches, multiple matches, stop/resume and no selected items need honest states and tests. Never erase history when moving an item.


### Slide 18 — Vocabulary Master / maintenance

**Visible design:** No sidebar; Master header and back button. Left Mastered Words table retains a book icon. Right pale-yellow test panel has selected/random/endless actions beside a tall thin robot. A moonlit window adds a subtle evening identity.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide8.xml):

> The way the mastery works is that if the user has failed the mastery they send the word back to practice word list. (after all the words here are mastered they gotta be tested)

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›`

**Actual comments:** None.

**Intended screen / flow:** Vocabulary → Mastered Words → harder maintenance check; failure → Relearning/Review with earlier follow-up.

**Implementation decision:** Keep book icon, original tall-thin artwork and understated cool accent. Graduation requires spaced, delayed, varied evidence including independent retrieval. Failing mastery records a new event and schedule transaction; preserve every earlier attempt.

**Deferred / unclear:** Exact tested scheduler/mastery policy and maintenance modes remain future work. Recognition-only quick successes do not establish mastery.


### Slide 19 — Word introduction

**Visible design:** Back button; tall-thin companion at left. Right top yellow card contains large Hanzi, Pinyin, English meaning, speaker control and illustrative photo stack. Lower card shows six numbered Chinese/English examples. A continue action is absent in the artwork.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide9.xml):

> This page is missing a button to continue to the test and there should be 5 examples not 6

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›`

**Actual comments:** None.

**Intended screen / flow:** Learn a word → inspect word/sense, available pronunciation and examples → Continue to Quiz.

**Implementation decision:** Apply the actual note: exactly five checked examples and a visible Continue to Quiz button. Use tone-marked contextual Pinyin and verified translations. Wire genuine lawful audio or explicitly show Audio unavailable. Keep content/sense identity separate from progress.

**Deferred / unclear:** The pictured word and examples are design examples, not verified curriculum. Do not copy arbitrary photo artwork from the deck or claim audio exists.


### Slide 20 — Quiz / Hanzi → meaning

**Visible design:** Cream rounded question panel with large Hanzi, meaning prompt and four dark rounded answer choices in a 2×2 grid; small supporting tall-thin robot on the left and a sunny background.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide10.xml):

> 1.7.2013
>
> 4
>
> ‹#›

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›` Entire body (`1.7.2013`, `4`, `‹#›`) is generic template material; no functional instruction.

**Actual comments:** None.

**Intended screen / flow:** Word session → select meaning → deterministic grading/feedback → next check.

**Implementation decision:** Use verified sense-specific options with one unambiguously best answer or explicit accepted variants. Prevent double submission, save the attempt reliably, distinguish recognition from production and show useful feedback. Keep subpage background simple and controls keyboard accessible.

**Deferred / unclear:** No actual functional speaker note; only generic body footer. Robot may vary across exercise families per latest user instruction rather than repeating this one everywhere.


### Slide 21 — Quiz / Hanzi → Pinyin

**Visible design:** Large Hanzi question and four dark Pinyin choices. The source options lack tone marks. This single raster artwork has a taller native aspect ratio than the deck and is stretched in the source layout.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide11.xml):

> 1.7.2013
>
> 4
>
> ‹#›

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›` Entire body (`1.7.2013`, `4`, `‹#›`) is generic template material; no functional instruction.

**Actual comments:** None.

**Intended screen / flow:** Word session → choose matching Pinyin → feedback.

**Implementation decision:** Use validated tone-marked Pinyin and appropriate distractors. Grade pronunciation identity from structured data, not display-string guesses. Adapt the composition responsively; do not preserve image distortion.

**Deferred / unclear:** Content review must verify polyphonic senses, tones and distractor ambiguity; no actual functional note.


### Slide 22 — Quiz / Pinyin → Hanzi

**Visible design:** Large romanized target with a prompt and four Chinese choices. The source Pinyin lacks tone marks and shares the stretched taller-raster issue.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide12.xml):

> 1.7.2013
>
> 4
>
> ‹#›

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›` Entire body (`1.7.2013`, `4`, `‹#›`) is generic template material; no functional instruction.

**Actual comments:** None.

**Intended screen / flow:** Word session → choose Hanzi for the intended pronunciation/sense → feedback.

**Implementation decision:** Present verified tone-marked Pinyin, adequate Hanzi size and contextual disambiguation where multiple words share pronunciation. Use a shared choice UI without merging distinct grading rules.

**Deferred / unclear:** This is recognition evidence; no mastery from this alone. No actual functional note.


### Slide 23 — Quiz / audio recognition

**Visible design:** Back button; cream question card asks which audio matches the target Hanzi. Four blue speaker controls appear in a 2×2 arrangement, with a companion at left.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide13.xml):

> 1.7.2013
>
> 4
>
> ‹#›

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›` Entire body (`1.7.2013`, `4`, `‹#›`) is generic template material; no functional instruction.

**Actual comments:** None.

**Intended screen / flow:** Word session → replay candidate audio → select a choice → feedback.

**Implementation decision:** Each of four playable controls needs an actual asset or supported TTS. Separate play/replay from answer selection to avoid accidental submissions. If required audio is unavailable, explain it and offer an appropriate alternate/skip path without awarding listening evidence.

**Deferred / unclear:** Audio availability, lawful distribution, playback errors and accessible labeling must be verified. Decorative speaker icons are not working audio.


### Slide 24 — Quiz / sentence ordering

**Visible design:** Back button; instruction panel with four dashed destination slots above four draggable word tiles. Small grip dots indicate dragging. A tall-thin robot stands at left.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide14.xml):

> 1.7.2013
>
> 4
>
> ‹#›

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›` Entire body (`1.7.2013`, `4`, `‹#›`) is generic template material; no functional instruction.

**Actual comments:** None.

**Intended screen / flow:** Word session → arrange tokens → submit → deterministic feedback.

**Implementation decision:** Support drag/drop plus tap-to-place, keyboard moves and undo/reset. Preserve token IDs (including repeated tokens), validate approved token sequences/accepted alternatives and normalize documented punctuation/spacing. Never grade by a simplistic raw concatenated string only.

**Deferred / unclear:** Question corpus must enumerate justified alternatives; free output and ordering are different evidence. No actual functional note.


### Slide 25 — Five sentence / translation pairs

**Visible design:** Back button and progress bar above a wide cream form. Five numbered English fields in a yellow column and five Chinese fields in a blue column; a robot separates the columns. Source progress fraction is illustrative and no submit action is shown.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide15.xml):

> 1.7.2013
>
> 4
>
> ‹#›

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›` Entire body (`1.7.2013`, `4`, `‹#›`) is generic template material; no functional instruction.

**Actual comments:** None.

**Intended screen / flow:** Productive exercise mode → five pairs → validate/save feedback; separately, custom-word intake from16 → five pairs → save unverified draft.

**Implementation decision:** Reuse a paired-sentence form while keeping the two workflows and record types distinct. Add explicit Save draft / Submit / Continue actions as appropriate; preserve inputs on errors. Validate required pairs, lengths and Unicode, warn about duplicate pairs and show per-field errors. Do not claim grammatical correctness from input presence or silently publish user text as approved content.

**Deferred / unclear:** Open-ended assessment/reviewer policy is deferred. No mandatory AI/API. Runtime progress derives from actual session state; no copied fraction.


### Slide 26 — Grammar lesson/chapter browser

**Visible design:** Sunny room with primary dark sidebar and Grammar selected. Peach chapter panels contain two-column white lesson cards, chapter headings, scroll affordance and distinct goggles/tracked robots. The same A-not-A label is repeated and there is no tutorial button.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide16.xml):

> This page is missing a tutorial button and it should use a grammar database instead of just repeating each lesson like the image says.

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›`

**Actual comments:** None.

**Intended screen / flow:** Grammar → chapter/pattern list → detail (27); tutorial/replay entry.

**Implementation decision:** Add tutorial/replay per notes15 and26. Populate distinct validated grammar patterns from a repository with prerequisite-aware availability. Foundational grammar begins early; raw word count alone cannot gate it. Use responsive lists/scrolling and restrained artwork.

**Deferred / unclear:** Distinct lesson content, prerequisite tests, empty/locked/error states and later review are subsequent work. Do not use repetitive placeholders as data.


### Slide 27 — Grammar detail / A-not-A example

**Visible design:** No sidebar; back button and A-not-A title across the top. Large left cream panel presents Meaning, Grammar Structure and rules; narrower right panel has three numbered examples with Chinese, Pinyin, English and short glosses. A small robot sits near the lower edge.

**Actual speaker-note body** (/ppt/notesSlides/notesSlide17.xml):

> The database for grammar questions should be (name, meaning, grammar structure, grammar rules, and examples).

**Other note placeholders / excluded material:** `1.7.2013`; `‹#›`

**Actual comments:** None.

**Intended screen / flow:** Pattern detail → worked examples → short comprehension/arrangement/output → feedback → scheduled grammar review.

**Implementation decision:** Store stable identity plus name, meaning, structure, rules, examples and prerequisites. Support A + 不 + A and special 有没有 form as one reviewed starter pattern, not the entire syllabus. Validate source Pinyin, translations and acceptable variants before shipping; preserve separate grammar progress.

**Deferred / unclear:** The deck designs an explanation page but not the complete exercise/review flow. Build incrementally with tested records. The source text is not automatic curriculum approval.
