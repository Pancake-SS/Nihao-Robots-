# Mandarin Learning App — Master Product & Build Plan

**Version:** 1.0 — 18 October 2026  
**Purpose:** A single, practical product brief for planning, AI-assisted coding, implementation, and testing.  
**Status:** Proposed design; features and schedules should be tested with real learners before making claims of educational effectiveness.

> **The product in one sentence:** A local-first Mandarin Chinese learning app that uses structured vocabulary, grammar, comprehensible input, and AI conversation to help learners **understand, remember, and use Chinese**, not merely collect streaks or complete quizzes.

---

## 1. The vision and feel

Build a Chinese language-learning application that is friendly, engaging, and genuinely useful. It should feel like a learning companion rather than an exam portal or a pile of flashcards.

**The four main sections are:**

1. **Vocabulary** — Learn new words, review them using spaced repetition, and maintain mastery.
2. **Grammar** — Learn useful sentence patterns, practice them, and review weak patterns.
3. **Immersion / Language Acquisition** — Discover appropriately leveled Chinese stories, videos, cartoons, readings, and listening resources.
4. **Texting / Talking Practice** — Converse with an AI companion/tutor using Chinese, with adjustable guidance and feedback.

The sections must share progress information. A weak word in Vocabulary might become the focus of a Grammar exercise, an Immersion recommendation, or an AI conversation prompt.

**Experience principles:**
- Calm, inviting, visually polished, and a little playful; never childish or cluttered.
- Short, meaningful lessons; optional deeper practice for motivated users.
- Show progress and achievements without shaming learners who miss a day.
- Give clear reasons for errors and let users try again.
- Avoid overloading beginners with difficult Chinese, too many buttons, or long theory explanations.
- Support both mouse/keyboard and touch-screen use, with readable Chinese characters, Pinyin, replay buttons, and accessibility-friendly contrast.
- Robot mascot artwork may be used as optional personality/decorative elements, but should not interrupt learning or substitute for useful feedback. Keep the mascots visually distinct rather than repetitive.

**Initial target:** English-speaking beginners learning **Mandarin in Simplified Chinese** with tone-marked Hanyu Pinyin. Store Traditional Chinese and other preferences where available so they can become selectable later.

---

## 2. Learning principles (the rules behind every feature)

The app is informed by research on spaced repetition, retrieval practice, comprehensible input, meaningful output, corrective feedback, and cognitive load. The four-section design draws on the complementary learning activities described by Paul Nation's *Four Strands* framework.

Implementation implications:

- **Recognition is not mastery:** selecting a correct translation is easier than independently remembering or using a word.
- **Review over time:** adapt future reviews based on success, difficulty, and elapsed time, not a simple count of five clicks.
- **Use context:** teach words with sentences and realistic situations, not isolated dictionary entries alone.
- **Ask learners to retrieve:** gradually move from multiple-choice tasks to typed or spoken answers without a word bank.
- **Provide targeted feedback:** distinguish vocabulary, grammar, comprehension, and pronunciation problems.
- **Use understandable material:** recommend reading and listening that contains mostly familiar language plus manageable new material.
- **Track skills separately where practical:** reading, listening, meaning recall, and independent use are distinct evidence.
- **Keep the system adaptable:** levels, question types, and daily objectives should respond to the learner's actual performance.

These are evidence-informed design choices, **not proof** that this specific app works. Delayed tests and user studies will be needed.

---

## 3. Getting started: beginner onboarding

A complete beginner must be able to understand early tasks before receiving difficult vocabulary quizzes.

**First-time flow:**
1. Select existing level (complete beginner / some basics / experienced) and goal (travel, everyday conversation, reading, etc.).
2. Choose Simplified Chinese + English explanations (default), Pinyin display preference, and a manageable daily goal.
3. Optional short placement quiz for users with prior knowledge; beginners can skip it.
4. Start a short **Foundation course** covering:
   - What characters, words, and Pinyin are.
   - Mandarin initials/finals and four lexical tones + neutral tone, including listen-and-distinguish exercises.
   - Pronouns, simple subject–verb–object sentences, basic questions with 吗, negation with 不, and common everyday expressions.
   - Basic listening and sentence comprehension using a very small, familiar word set.
5. Unlock the first vocabulary lesson, with essential grammar still taught alongside it.

**Important:** Do not block *all* grammar until 50–100 mastered words. Foundational grammar begins immediately. More advanced Grammar lessons unlock once relevant vocabulary and prerequisite patterns are understood. A 50- or 100-word milestone may be an achievement, not the sole unlock condition.

---

## 4. Vocabulary: three visible stacks, one adaptive learning engine

Keep the original three-stack concept. These are what users **see**; an independent scheduler manages actual review dates and learner history.

### A. New Words (learn and pass an initial checkpoint)

For each word, present:
- Simplified characters, optional Traditional characters, correct Pinyin with tone marks, English meaning, part of speech, and audio.
- One short understandable example, its translation, and later a few varied examples.
- Where useful, a picture, collocation, or a concise note about usage.

**Exercise sequence (not necessarily every question for every word):**
1. Learn the meaning and listen to pronunciation.
2. Pick its meaning or identify the word after hearing audio.
3. Choose the word's correct use in one of several different sentences.
4. Recognize a similar-sounding/different-tone word where appropriate.
5. Recall Chinese from English, complete a short sentence, or type the word without multiple-choice clues.
6. Take a short mixed checkpoint quiz covering the newly introduced items.

On sufficient initial performance, a word leaves **New Words** and enters **Review**. Failure gives an explanation and a supported retry; it does not create a permanent penalty.

### B. Review / Progression (prove memory across time)

- The first follow-up review may be due about **5 minutes after initial learning**, as originally imagined. Treat this as a tunable early learning step, not a universal spacing rule.
- Then increase/decrease intervals based on review quality and elapsed time. Use an established spaced-repetition algorithm such as **FSRS**, via a maintained Dart implementation if compatible and adequately tested.
- Ask different questions on different reviews: meaning, audio recognition, contextual comprehension, and recall without choices.
- Record the date, exercise type, correctness, hint usage, and the response's quality/difficulty.
- The app can describe progress as “2/5 successful checkpoints” for motivation, but five rapid repetitions **must not** automatically qualify as lasting mastery.

**Graduation to Mastery:** Require several successful *spaced* reviews, including a genuinely delayed check and at least one independent-recall/contextual-use assessment. Exact thresholds are configurable, and should be calibrated from real use.

### C. Mastery (maintenance and harder checks)

- A mastered word remains in the system and receives occasional longer-interval maintenance checks.
- Tests become more demanding: independently produce the word, understand it in unfamiliar text/audio, or use it in a new sentence.
- A failed mastery check sends the item to **Relearning/Review**, with earlier follow-up, **without wiping the full learning history**.
- The interface can retain the feeling of maintaining mastery, but should not punish a single lapse as though the user never learned the word.

**Example word record:** `学习` — `xuéxí` — “to study / learn”; linked to verified sentences, word audio, sentence audio, grammar tags, and personal review history. The word data is shared; the learner's knowledge is stored separately.

**Critical quality rule:** Do not equate a multiple-choice success, recognizing a familiar audio clip, and producing a new sentence with the same level of evidence.

---

## 5. Grammar: study and review

Grammar is presented through useful sentence patterns rather than lengthy linguistic lectures.

**Two visible lists:**
- **Study:** New/unlocked grammar patterns and worked examples.
- **Review:** Previously learned patterns due for varied practice.

**Sample grammar lesson sequence:**
1. Show 2–3 short understandable sentences sharing the pattern.
2. Ask the learner what is similar or different.
3. Give one brief explanation of the pattern and a common error.
4. Have the learner interpret, arrange, complete, and eventually produce a sentence.
5. Record mistakes and schedule a later review with different examples.

**Unlock logic:** A lesson can require both (a) certain prerequisite patterns and (b) sufficiently familiar vocabulary needed for its examples. Do not simply unlock by raw word count. Optional early previews can exist, but assess with appropriately leveled sentences.

**Starter patterns:** basic word order, 是, 有, 不/没, 吗 and question words, simple time expressions, 的, measure words such as 个, common location phrases, and eventually 了, comparisons with 比, and more complex constructions.

Store grammar patterns independently from words, then link them to example sentences and prerequisite items. Use the same underlying review engine but distinct progress records.

---

## 6. Immersion / Language Acquisition: understandable input

This section gives the learner opportunities to **read and listen for meaning**, not just answer quiz questions.

**At launch:** A small, curated, searchable catalog of resources: short stories, graded readings, YouTube-style videos, animations/cartoons, and other legitimately accessible Chinese material. For external content, store a link and metadata instead of embedding giant files.

Each resource should ideally have:
- Title, resource type, source URL, duration, level, theme/topic.
- Target vocabulary and grammar tags where available.
- Transcript and subtitles when licensed/permitted; mark whether they exist.
- Optional comprehension questions and a short post-activity reflection.

**Recommendations:** Prefer content related to words/patterns the learner knows, plus a manageable amount of new language. Also account for sentence complexity, audio speed, and actual comprehension performance—not only a static level label.

**Later additions:** clickable words in permitted transcripts, add a word to the learning queue, short graded readers inside the app, and comprehension-based recommendations.

**Copyright rule:** Linking to authorized public resources is different from copying and redistributing movies, cartoons, books, or transcript text. Store and distribute only what is properly licensed.

---

## 7. AI Texting / Talking Practice: a companion that also teaches

The AI should be personable and flexible enough for friendly conversations, jokes, stories, and everyday chat, **but** it should also know the learner's level and help them improve.

**Default conversation experience:** The learner writes in Chinese; the AI can reply in English at beginner level, optionally introducing short Chinese expressions. Later levels may use simple Chinese or full Chinese with optional translations.

**Two selectable modes:**
- **Free Chat:** Natural conversation, minimal interruption; optional corrections on request or after the session.
- **Tutor Chat:** Work on selected vocabulary/grammar, ask follow-up questions, provide hints, prompt self-correction, and explain mistakes concisely.

**Capabilities:**
- Named, saved conversation sessions with a simple resume/delete function.
- Use the learner's studied words and weak skills to propose prompts naturally.
- Optional “Review my Chinese” summary at the end: recurring mistakes, suggested corrected phrases, and relevant review items.
- Adjustable feedback intensity (light / normal / detailed), Pinyin and translation help.
- A visible indication when the AI is unavailable, with no interruption to offline learning.

**Important AI boundaries:**
- AI can suggest practice and flag possible mistakes; it must not unilaterally mark a word “mastered.”
- Do not depend on AI for routine fixed-answer vocabulary questions.
- Generated content requires validation before publishing it as canonical curriculum material.
- Save personal chat content only with clear user controls; provide deletion/export options.

**AI service strategy:** Support a configurable provider interface. Start with a suitable API provider or a local model, subject to actual quotas/hardware. There is **no guaranteed unlimited free AI API**. Do not assume a cloud model works offline.

**Voice (later feature):** Begin with microphone → speech recognition → transcript confirmation/editing → AI reply → optional speech synthesis. A real-time voice call and precise tone/pronunciation grading are significantly harder and should not be MVP requirements. Speech-to-text accuracy is **not** a reliable pronunciation score by itself.

---

## 8. Motivation, daily missions, and progress dashboard

Keep streaks and rewards but avoid making them mathematically impossible for new learners.

**Original idea to preserve:** The app motivates users to do new vocabulary, normal reviews, mastery maintenance, and grammar reviews—rather than only farming easy new-word points.

**Improvement:** Generate a **daily mission based on what is available and due**. Example for a learner with content in each section:
- 3 new words
- 5 due vocabulary reviews
- 2 mastery maintenance checks
- 1 grammar review or short grammar exercise
- 3 minutes of immersion (optional bonus)

If there are no grammar reviews or mastery checks due, swap them for suitable available tasks. Give a low-effort minimum mission to support habit formation; tougher 10+10+10+10 challenges can be optional bonus achievements.

**Rewards:** Streak freezes, extra attempts in casual challenges, mascot cosmetics, and visual badges. Rewards should **not** convert incorrect answers into mastery evidence or skip essential learning steps.

**Dashboard:** Show due reviews, learned/reviewed/mastered items, current grammar progress, practice time, missed patterns, and delayed-retention evidence. Label any “knowledge percentage” as an estimate rather than a proven proficiency score.

---

## 9. Selected datasets: minimal, complementary, and practical

Use **two main content sources first**. They are the strongest match to this app's vocabulary + contextual listening model. Additional sources are optional rather than automatic requirements.

| Priority | Source | Why it was selected | Integration / limitations |
|---|---|---|---|
| **1 — Vocabulary foundation** | **[HearMandarin HSK 3.0 Word List](https://hearmandarin.com/datasets/)** | Structured word IDs, Simplified/Traditional, Pinyin, English teaching glosses, part of speech, HSK band/level. Good starter curriculum backbone. | CSV/JSON, CC BY 4.0 with attribution. **No distributable word audio is included.** Validate high-priority glosses; the site says many are machine-prepared. |
| **2 — Sentences, grammar tags, listening** | **[HSK Sentences Audio](https://github.com/no7z/hsk-sentences-audio)** | 4,354 leveled sentences with translations, Pinyin, segmented glosses, grammar-point tags and normal/slow synthetic audio. Very close to the exercise system needed. | `dist/sentences.json`, optional MP3 packs; dataset CC BY-SA 4.0 and source attribution obligations. Approx. 170 MB for all audio; use selected level/topic packs, not a mandatory full download. |
| **Optional — Dictionary fallback** | [CC-CEDICT](https://cc-cedict.org/editor/editor.php?handler=Download) | Extra meanings and entries missing from the HSK set. | CC BY-SA 4.0; keep provenance and check share-alike implications for adaptations. Not needed for initial 100 words. |
| **Optional — More examples** | [Tatoeba](https://tatoeba.org/en/downloads) | Additional example sentences and translation pairs, including some audio. | Filter for naturalness, difficulty, and correct sentence/audio-specific license. |
| **Optional — Ordering by frequency** | [SUBTLEX-CH](https://www.ugent.be/plone_portal/pp/experimentele-psychologie/en/research/documents/subtlexch/overview.htm) | Helps prioritize common everyday words alongside HSK level. | Not a dictionary; verify reuse terms before redistribution. Not necessary for the MVP. |

**Deliberately defer:** HSK Annotated Corpus (very large and requires source/license/quality auditing), alternative unofficial word lists, and full-scale automated imports. Avoid combining multiple overlapping word lists until IDs, duplicate detection, and source provenance are reliable. Official HSK/syllabus materials can guide curriculum organization, but their redistribution rights require separate checks.

**Dataset import approach:**
1. Import HearMandarin CSV/JSON into a **staging** content database.
2. Import HSK Sentences Audio JSON and map words to sentence examples and grammar tags.
3. Select and manually check a **small launch curriculum (~100 words and 10–20 grammar patterns)** first. Expand to ~150–300 curated words after the initial flow works.
4. Review pronunciations, segmentation, level fit, sentence meaning, and questions with potentially multiple valid answers.
5. Generate **word audio** with a suitably licensed local/browser TTS approach or other permitted source. Sentence audio already exists in the selected dataset. Do not assume the HearMandarin dataset includes MP3 word files.
6. Store source URL, source ID, source license, attribution, and content version for every imported record or asset.
7. Publish validated content to the app as a versioned offline pack; download optional sentence-audio sets by level/topic.

**AI-generated example sentences:** Allowed as *draft content*. Generate at the learner's level, run checks for vocabulary/grammar difficulty, human-review important examples, and save accepted results. Do not call an AI endpoint to regenerate the core curriculum every time a learner reviews a word.

**Word IDs:** Use stable app IDs and preserve original source IDs; the Chinese string alone is not a safe primary key because different word senses or pronunciations may share characters.

---

## 10. Technology and deployment decision

There are **two prior ideas**: a localhost React/Flask web prototype and a later cross-platform Flutter app with synchronized accounts. To avoid building two incompatible foundations, use **one recommended stack for the planned product**:

| Layer | Recommended choice | Reason |
|---|---|---|
| UI / client | **Flutter + Dart** | One codebase aimed at Android, Windows, then iOS/macOS where feasible. |
| App state | **Riverpod** | Keeps screens, lesson state, and services organized. |
| On-device database | **SQLite + Drift** | Offline-first content, personal progress, reviews, and saved chat metadata. |
| Review algorithm | **Dart FSRS library (evaluated/tested before adoption)** | Established adaptive spaced repetition instead of a home-grown five-repeat scheduler. |
| Optional cloud sync (later) | **Supabase Auth + PostgreSQL + Storage** | Accounts, relational content updates, private progress, synced history across devices. |
| Optional AI | **Pluggable cloud API or local model** | Keeps AI removable and avoids tying the core product to one provider. |

**What “local-first” means:** After installation/content download, onboarding for an offline local profile, lessons, quizzes, scheduling, and progress should operate without a backend server. The development app runs locally on the developer's machine; it need not be a browser page at `localhost` because Flutter builds native apps. Internet is needed for cloud sync, external media links, and cloud-based AI.

**If literal browser-on-localhost operation is a strict requirement:** Make that a conscious **alternative architecture decision before coding** (React/Vite + Flask/FastAPI + SQLite). Do **not** mix Flutter and React implementations during the MVP. The Flutter route is chosen here because the added discussion explicitly prioritizes desktop/mobile support and later cross-device synchronization.

**Rollout strategy:**
- **MVP:** One local profile, SQLite, Windows desktop target first, Android next; no mandatory account, no required internet, no cloud backend.
- **After MVP:** Opt-in Supabase account and synchronization; downloadable content updates; additional device builds.
- **Later:** AI voice, more sophisticated adaptation, large content library, and additional languages/scripts if desired.

**Cloud sync design (later, not automatic):** Supabase does not automatically merge arbitrary SQLite databases. Save immutable review **events** with unique IDs locally, upload them when connected, deduplicate on the server, and derive up-to-date review state from events. Test the case where a learner studies offline on both mobile and desktop before reconnecting. Use user-owned access policies (RLS), and do not overwrite all history with the latest timestamp.

**Security:** Never bundle a shared AI provider secret, Supabase service-role key, or DB admin password in client code. For a hosted model, use a secured server-side proxy/edge function or a deliberate user-provided-key option with safe local storage. Provide privacy settings and chat deletion. A local-only profile requires no account.

---

## 11. Minimum database / data entities

Keep the initial database simple. The important relationships are:

**Shared learning content (versioned):**
- `words` — stable word ID; Simplified/Traditional; Pinyin; level; POS; source metadata.
- `word_senses` — meaning, usage/context, register (when applicable).
- `sentences` — sentence ID; Simplified/Traditional; translation; Pinyin; level/topic; source.
- `word_sentence_links` — which words/senses occur in which sentences.
- `grammar_patterns` — ID, explanation, examples, prerequisites, level.
- `grammar_sentence_links` — patterns illustrated by a sentence.
- `audio_assets` — local path/URL, word/sentence link, voice, speed, license, downloaded state.
- `resources` — immersion URL, type, tags, level, availability/rights metadata.
- `exercises` — question type, target item/sense/skill, prompt, accepted answers, hint, explanation.
- `content_versions` — which verified content pack is installed.

**Private learner state:**
- `profiles` / `settings` — level, goal, display/script preferences, local account ID.
- `item_progress` — per user + item/sense/skill, visible stack, review state, due date, scheduler data.
- `review_events` — every answer, timestamp, question type, success, hint, difficulty rating, unique event ID.
- `grammar_progress` — studied/unlocked/due state and prerequisite completion.
- `daily_activity` / `rewards` — streaks, missions, bonuses.
- `chat_sessions` and `chat_messages` — optional conversations, timestamps, objectives.
- `sync_outbox` — pending changes when cloud sync is enabled later.

Not every optional field/table needs a separate feature on day one. Use database migrations and test that importing new content does not erase learner progress.

---

## 12. Core user journeys to build and test

**Journey A — Brand-new learner:** Open app → create local profile → complete bite-sized Foundation lessons → learn `我 / 你 / 是` → pass an introductory quiz → first review scheduled after a short delay → close app → return later → see correct due review.

**Journey B — Vocabulary maintenance:** Complete a variety of spaced reviews → word graduates from Review to Mastery → a later hard test requires contextual use → failure schedules relearning while preserving history.

**Journey C — Grammar prerequisites:** Learn basic words and sentence order → a matching grammar pattern unlocks → practice with mostly familiar words → wrong answer creates a future targeted review.

**Journey D — Immersion:** Open recommendations → select a short resource matched to known vocabulary → watch/read externally or within licensed reader → answer one or two comprehension questions → optionally save a new word.

**Journey E — AI tutoring:** Start Tutor Chat → answer in Chinese → AI asks a relevant follow-up and supplies a hint if needed → finish session → view corrections and optionally add a missed phrase to practice.

**Journey F — Cross-device later:** Study offline on phone → local result saved instantly → reconnect and sync → sign in on desktop → see correct review history and remaining due items; no duplicated/erased answers.

---

## 13. Build roadmap and what NOT to overbuild

### Phase 1 — Playable learning MVP (highest priority)
- Flutter skeleton and four navigation destinations (nonimplemented sections clearly labeled).
- Local learner profile, Foundation lessons, readable Chinese/Pinyin UI.
- 50–100 **verified** starter words and a handful of basic grammar patterns.
- New Words → Review → Mastery interface and working review scheduling.
- Typed/choice/context/listening exercises and clear error explanations.
- SQLite persistence, review history, due-date logic, basic dashboard.
- Automated tests for schedule changes, stack transitions, correct answers, persistence, and restarts.

**Done when:** Someone can learn a word, leave the app, return after the scheduled time, complete an appropriate review, and see persistent accurate progress—without internet access.

### Phase 2 — Quality content and connected study
- Expand to ~150–300 validated words.
- Grammar Study and Review, unlock rules, curated immersion catalog.
- Optional downloaded audio packs, more question types, daily missions/streaks.
- Content import/validation tooling and versioned updates.

**Done when:** The curriculum appropriately combines vocabulary, grammar, and input without impossible unlocks or missing audio/answers.

### Phase 3 — AI conversation and accounts
- Free/Tutor Chat modes, saved sessions, corrective feedback and optional post-chat reviews.
- Clear AI unavailable/offline fallback.
- Optional Supabase login, cloud data model, event-based sync, and private-data policies.
- Android + Windows cross-device sync tests.

**Done when:** The learner can use AI meaningfully without corrupting mastery scores and can sync between supported devices without losing offline work.

### Phase 4 — Refinement and advanced practice
- Push-to-talk audio + transcript confirmation; optional TTS responses.
- Better weak-skill targeting, richer graded readers, personalized recommendations.
- Alternative script support, optional local LLM, more platforms, larger curriculum.
- Learning-effectiveness pilot with immediate, delayed, and novel-context assessments.

**Avoid in Phase 1:** Fully automated AI curriculum writing, unlimited voice chat, real-time accent grading, every HSK word, a large admin panel, fancy sync-conflict handling, complicated character animations, or a mandatory cloud account.

---

## 14. Quality and acceptance rules for AI coding assistants

These rules protect the project from “looks good but doesn't work” implementations:

1. **Build vertically, not all at once:** finish one end-to-end feature including data, UI, persistence, validation, and tests before starting the next major feature.
2. **One truth per concept:** language content and personal learner progress must be separate. Never calculate mastery from a UI counter alone.
3. **Deterministic core:** review scheduling, exercise answers, grammar prerequisites, and streak eligibility should be deterministic/testable functions. AI must not be required to operate these functions.
4. **Correct Chinese first:** don't invent bulk educational content. Use curated test fixtures until the import pipeline is validated.
5. **Offline must be real:** core learning functionality should work without network access after downloading content.
6. **Explicit loading/error states:** missing audio, unavailable AI, bad import records, or a failed sync should produce understandable behavior rather than blank screens.
7. **Do not put secrets in code:** environment variables or secured service configuration only; explain any backend requirement.
8. **Stable schema:** use migrations and stable IDs; never silently drop learner data during updates.
9. **Small, testable code:** separate UI, persistence, exercise engine, scheduler, dataset import, and AI adapters.
10. **Be honest about unimplemented work:** mark placeholders and known limitations; don't claim that a feature works without having tested it.
11. **Track source rights:** retain licensing/attribution and provenance for each dataset and audio asset.
12. **Accessible and responsive:** make Chinese characters large and legible; allow audio replay and optional hints.

### Suggested MVP test checklist
- [ ] New learner can finish onboarding without existing vocabulary or mastery reviews.
- [ ] The app doesn't require login or internet to do offline lessons.
- [ ] All starter exercises have valid answers, including cases with alternative correct Chinese phrasing.
- [ ] Wrong answers show useful feedback and do not automatically count as mastery.
- [ ] The first review is delayed and the due state survives restarting the application.
- [ ] Different review results produce appropriate later due dates.
- [ ] Graduation to Mastery includes delayed, varied, independent retrieval evidence.
- [ ] A failed mastery review schedules relearning without deleting history.
- [ ] Grammar unlocks by prerequisites, not only 50–100-word totals.
- [ ] Missions never demand content the learner cannot access or does not have due.
- [ ] Offline/missing audio and unavailable AI have graceful fallback behavior.
- [ ] Dataset sources and license information are retained.

---

## 15. Copy/paste starter prompt for a vibe-coding assistant

> **You are helping build a local-first Mandarin learning application. Read and follow this entire Master Product & Build Plan as the product specification.**
>
> Use **Flutter + Dart**, **Riverpod**, and **SQLite/Drift** for the initial Windows-first MVP, designed so Android can follow. No required Supabase or AI API in Phase 1. Keep shared Chinese content separate from personal learner progress. Use verified sample content initially. Implement a reliable vocabulary journey with New Words, Review, and Mastery, backed by a tested spaced-repetition scheduler, including a short initial delayed review and later adaptive intervals. Add basic beginner onboarding and foundational grammar early. Use Simplified Chinese, tone-marked Pinyin, English explanations, and a clean, welcoming design.
>
> **Do not attempt the whole plan in one coding pass.** First propose a small feature-by-feature task breakdown and folder structure. Then implement **Phase 1 only**, beginning with app shell, local database, a few verified sample words, and one end-to-end learn→quiz→review flow. After each task, tell me which files changed, how to run it, what tests were executed, and what remains unfinished. Do not fabricate data, tests, or functionality. Ask before making major stack changes or adding paid services. Later phases (immersion, AI conversation, accounts/sync, voice) should be supported architecturally but should not be implemented prematurely.

---

## 16. Decisions to confirm later (not blockers for starting)

- Final app name and visual identity/mascot use.
- Windows-first desktop prototype versus Android-first test device (the spec assumes Windows first).
- Whether Traditional Chinese becomes a user-selectable option in Phase 2 or later.
- Which exact FSRS Dart package version to lock after testing against expected review behavior.
- Which cloud AI provider/local model is economical and suitable for Chinese at integration time.
- Whether users can disable session saving or opt in to cloud sync independently.
- Whether the app eventually needs a **browser localhost version**; if yes, treat it as a deliberate architecture change or separately planned client, not a surprise addition midway through MVP development.

---

## 17. Main references and data links

**Project sources:** The user's *Language Learning Research Guide* (research rationale), original app concept and design evaluation, and two supplementary research conversations about Chinese datasets and cross-device architecture.

**Scientific and curriculum references:**
- Dunlosky et al. (2013), *Improving Students' Learning With Effective Learning Techniques*: https://doi.org/10.1177/1529100612453266
- Nation (2007), *The Four Strands*: https://doi.org/10.2167/illt039.0
- CEFR descriptors: https://www.coe.int/en/web/common-european-framework-reference-languages/cefr-descriptors
- Chinese HSK reference: https://www.chinesetest.cn/hsk

**Chosen technical/data references:**
- HearMandarin downloads and license: https://hearmandarin.com/datasets/
- HSK Sentences Audio repository and attribution: https://github.com/no7z/hsk-sentences-audio
- Dart FSRS package repository: https://github.com/open-spaced-repetition/dart-fsrs
- Flutter documentation: https://docs.flutter.dev/
- Drift local SQL storage: https://drift.simonbinder.eu/
- Supabase documentation (later phase): https://supabase.com/docs

**Final product goal:** A learner's next activity is selected by what they can **understand, recall, hear, write, and meaningfully use**, not just how many lessons they've clicked through.
