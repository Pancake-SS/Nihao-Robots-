# Ni Hao Robot! — Decision log

## 2026-11-03: source reconciliation and bootstrap scope

Authority: latest user prompt, then Master Plan, Coding Standards, actual PPT notes/comments, then slide artwork.

| Conflict / decision | Resolution and consequence |
|---|---|
| Slide 1 login/signup; Master Plan avoids mandatory accounts | Multiple local profiles with isolated progress. No password form or example credentials. Latest prompt also supersedes the plan's single-profile MVP suggestion. |
| Master Plan four learning areas; PPT five navigation labels | Keep Home, Vocabulary, Grammar, Practice, Speaking at top level when the shell is built. Preserve Immersion in backlog; no invented finished screen. |
| Vocabulary Practice versus primary Practice | Slide 17 is vocabulary review and must work in Phase B. Primary Practice/Speaking stay explicitly deferred. |
| Mastery failure “back to practice” | Append an attempt, schedule Relearning/Review transactionally; never delete history. |
| Five rapid checkpoints versus mastery | Only spaced, delayed, varied, independent evidence may graduate an item. Evaluate a maintained FSRS package before selecting its version. |
| Slide 19 six example rows | Follow note: exactly five checked examples and Continue to Quiz. |
| Slide 16 duplicate “cancel” plus confirmation | Preserve form input, show possible matches and let the learner decide; different senses are legitimate. Custom examples remain unverified drafts. |
| Repeated vocabulary/grammar rows and sample dashboard counts | Use stable verified content IDs and real profile data; no storyboard values become seed data. |
| Master Plan launch dataset size / immersion versus latest phased brief | Begin with a tiny checked pack after profile persistence works; defer imports and Immersion UI. No external dataset claims/licenses treated as newly verified. |
| Original robots and latest variety request | Ten character pairs, selected for the local surface; stable varied assignments. White-backed black-line originals sit on white cards. Preserve all bytes. |
| Initial workspace contains starter documents only | No app, learner database, tests or Git repository existed. Build only a minimal scaffold while the Flutter SDK is unavailable. No architecture migration is involved. |
| Dependencies cannot be resolved/tested without Flutter | Do not invent a pubspec lockfile or handwritten Windows runner. First scaffold uses Flutter SDK only; add Riverpod/Drift with resolved compatible versions in the profile slice. |

## Recovery and change discipline

The original PPTX, Markdown specifications and robot images remain untouched. Keep existing dated project-memory decisions. Word is a generated mirror; canonical Markdown is the recovery source. Database creation is deferred; future schema changes require tested migration and recovery before use. No cloud, paid API, AI, analytics or runtime network dependency is introduced.
