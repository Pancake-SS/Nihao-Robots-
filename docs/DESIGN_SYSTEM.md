# Ni Hao Robot! — Design system

## Vocabulary checkpoint — 2026-11-06

Catalogue cards show actual lesson counts and support Hanzi/Pinyin/English search. Lesson details include Traditional Hanzi and source labels; imported example cards have Play sentence/Stop audio controls with synthetic/offline labeling and explicit retry. Quiz layout supports variable banks, four shuffled choices or a Simplified Chinese input, and a dynamic progress indicator. Audio stops on entering a quiz. The imported lesson journey passes 360 × 640 / 200% text testing. No new artwork or changed original robot pixels.

Status: initial implementation specification, 2026-11-03. Native Flutter, Windows first. The storyboard supplies composition and mood; this document sets reusable production rules. See SLIDE_REQUIREMENTS.md for individual flows and ASSET_MANIFEST.md for original artwork.

## Color tokens

| Token | Value | Use |
|---|---|---|
| cream | `#FAF7EF` | Main canvas |
| paper | `#FFFFFF` | Forms, cards, opaque light robot backing |
| navy | `#222C3B` | Primary text, navigation, primary buttons |
| mutedInk | `#536074` | Secondary text on cream/paper |
| border | `#DEDCD5` | Subtle card borders; not sole control boundary |
| yellow | `#F4D77B` | Warm highlight surface |
| sky | `#DCECF5` | Learning section accent |
| peach | `#F5DFCC` | Review section accent |
| sage | `#DDE8D7` | Supportive success surface |
| pink | `#EEDDE4` | Occasional detail |
| errorInk | `#9E3038` | Error text with explicit explanation |

Use navy text on pastel surfaces and white text on navy. Pastels are fills, not small text colors. Check rendered text/control contrast before release (4.5:1 normal text, 3:1 large text/control boundaries); never communicate state by color alone. No gradients or glow are required. Keep night accents confined to a small Mastery panel.

## Type, spacing and controls

- Default system sans serif initially; Windows fallback: Segoe UI and Microsoft YaHei for Chinese. Android: platform fallback. Bundle Nunito/Inter and a Chinese family only after license and glyph checks. Do not fetch fonts at runtime.
- Headline 36/44, section 24/32, card title 20/28, body 16/24, helper 14/20; Hanzi in lesson focus 40–56. Pinyin remains selectable, clear, and tone marked.
- Spacing scale: 4, 8, 12, 16, 24, 32, 48. Card radius 20; inputs/buttons 12. Use a restrained 1 px border and only light shadow where hierarchy needs it.
- Minimum pointer/touch target 48 logical pixels. Every action gets a meaningful label, hover/focus feedback, and keyboard activation. No icon-only action without a tooltip and semantics.
- Inputs show labels, preserve drafts on validation/duplicate warnings, and place errors adjacent to the field. Disable duplicate submissions only while a save is active; expose retry after failure.

## Layout

- Reference canvas 1440 × 900. Use constraints and scrolling, never fixed screen dimensions.
- Wide layout at 1100+: top-level sidebar about 220–240 wide, 32–48 content padding, reading area bounded to about 1120.
- Medium 700–1099: compact top-level navigation, 24 padding, cards wrap as space permits.
- Small below 700: single column, 16 padding, scroll; accessible navigation and forms stay visible. Re-evaluate actual text length and scaling, not viewport width alone.
- Activity/subpages use back navigation and a top header, without the dark sidebar. Long lists are lazy; forms and sentence examples scroll naturally.
- Test 1440 × 900, 900 × 700 and 360 × 640 with text scaling up to 200%; allow vertical growth and wrapping.

## Robots and illustration restraint

- All 20 source PNGs remain byte-for-byte unchanged in `Robot images/`. Copy only needed assets into the bundle and verify hashes. No tint, crop, background removal, mirroring, distortion, invented poses or generated replacements.
- The ten black-line versions are opaque white images: place them on true white cards. The ten white-line versions are transparent: use on navy. Choose according to the local surface, not only the app's global theme.
- Use explicit character/variant mapping from the manifest; numeric filename suffixes do not identify matched pairs.
- Choose stable, distinct characters by screen role. Avoid repeating one mascot throughout navigation and lessons. Usually zero or one robot on a functional subpage; a welcome composition may use two distinct characters.
- Original images include whitespace. Preserve it; size the composition around it. Use `BoxFit.contain` and no color filter. Decorative robots are excluded from accessibility semantics when nearby text already conveys the message.
- Main landing pages may suggest sunlight with a small warm accent surface. Subpages stay calm and mostly paper/cream. Do not bundle PPT screenshots or unlicensed room illustrations.

## Components and truthfulness

Build shared theme, card, button, field, loading/error/empty states as needed by each slice. Current shared components include the theme, original mascot renderer, learning card and contextual spotlight tour.

The profile picker implements Create Local Profile / Choose Profile / Continue, no passwords. Future Home statistics must come only from persisted learning progress; current Home explains that dashboard metrics are not yet available. Milestones label word counts, never a proven fluency percentage. Vocabulary Learn and Practice open the pilot catalogue and real review list; Master remains pending. Top-level Practice and Speaking say “Coming later — design pending.” Future Grammar uses real records and prerequisites. No guessed Immersion UI.

Tutorial overlays must spotlight real controls, keep Back/Next/Close reachable, support keyboard focus and replay, and include Vocabulary and Grammar. Missing audio shows a clear unavailable state and offers a suitable non-audio activity; never pretend a sound played.

## Current implementation boundary

The welcome composition now hosts working local profile creation/selection backed by Riverpod and Drift. The introduction was shortened to keep the form and save action visible at 1440 × 900. Buttons have a 48-pixel minimum visual height. Profile cards and the Pinyin switch have a Material surface so selection/ink feedback remains visible.

Home shows persisted learning preferences and a working introduction action with the tracked robot. The nine-page introduction uses a plain header/back route without the navigation sidebar. Vocabulary has three distinct original robots. Wide screens have a navy sidebar; narrow screens/large text use a wrapping navigation area in the scrollable page. Home, Vocabulary and Grammar tours spotlight live targets with Back/Next/Close and keyboard support. No fake learning counters or exercises are present.

All introduction pages and tours are tested at 360 × 640 with 200% text; keyboard Enter/Escape are covered. Desktop Home, Vocabulary, tour and Pinyin compositions were visually reviewed with system fonts. Native Windows launch remains a separate verification gate.

The pilot lesson, quiz, saved result and review list use back-header subpages without the primary sidebar. Choice buttons expose selected semantics and visible radio indicators. Submitted choices freeze so a retry preserves the original payload; saving blocks duplicate submission, then exposes retry or a recoverable conflict message. Feedback appears only after the transaction succeeds. Due counts and dates come from the active profile's records; missing content retains progress and explains why reviewing is unavailable. No additional artwork or duplicate mascot was added. Desktop renders and a narrow 200%-text quiz/retry flow were checked.

The production learning list is now a priority queue. It fetches 20 rows at a time and appends another 20 with See 20 more. Clicking a row sets a visible border, background and radio indicator; one shared Learn button opens that lesson. Move up/down/to front and Restore priority order are explicit controls. Headers scroll with the list to remain usable at 200% text; the bottom link returns to the Learn button. The queue has a back header and source-attribution action, with no primary sidebar. Lesson pages disclose source-imported review status and missing examples/audio.


## Word learning pages (2026-11-09)

The word browser uses up to 20 selectable cards per page. Desktop layouts fit
five columns; narrower windows and large text use fewer columns with a bounded
page scroll. Search and a filter dialog remain available. Previous/Next and the
selected word's Learn button stay outside the scrolling grid. Priority ordering
replaces manual move controls. Selected cards use the primary-container fill,
stronger border and a check icon, with selected semantics for assistive tools.

Lessons lead with Hanzi, optional Pinyin, a short gloss and word audio. FMLD
meaning/usage sections show three senses initially and expand further meanings.
Example cards show Chinese, optional Pinyin, translation and audio. Attribution,
review status, identifiers and speech caveats belong in the app-bar info dialog.
