# Ni Hao Robot! — Design system

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

Build shared theme, card, button, field, loading/error/empty states as needed by each slice. The initial scaffold only implements theme and a welcome composition. A reusable mascot widget is justified by its two surface variants.

Future profile picker: Create Local Profile / Choose Profile / Continue, no passwords. Home statistics come only from persisted profile progress. Milestones label word counts, never a proven fluency percentage. Vocabulary has Learn, Review/Practice, Mastery. Top-level Practice and Speaking say “Coming later — design pending.” Grammar uses real records and prerequisites. No guessed Immersion UI.

Tutorial overlays must spotlight real controls, keep Back/Next/Close reachable, support keyboard focus and replay, and include Vocabulary and Grammar. Missing audio shows a clear unavailable state and offers a suitable non-audio activity; never pretend a sound played.

## Initial scaffold boundary

The welcome composition is a source-only bootstrap, not a completed profile or learning flow. No counters, lesson data, authentication, database or working learning CTA are fabricated. Riverpod and Drift are reserved for the next testable slice after Flutter tooling is available.
