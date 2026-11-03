# Original robot asset manifest

Audit date: 2026-11-03 (Asia/Kuala_Lumpur). Status: all 20 supplied PNGs opened, measured, hashed, and visually inspected on cream and navy backgrounds. The source files remain unchanged. These are supplied project assets; no external artwork or generated replacement characters were added.

## Source and theme findings

- Source folder: `Robot images/`. All files are 1254 × 1254 pixels. Together they occupy 14,871,017 bytes; all 20 SHA-256 values are distinct.
- Ten `05_06_*` files contain black outlines on **fully opaque white square backgrounds**. Use them on a white illustration surface within the light interface. Do not assume transparency, tint them, or erase their backgrounds.
- Ten `06_17_*` files contain **white outlines with real transparency**, including partially transparent edge/detail pixels. Use these supplied variants on a dark navy surface. They become difficult to see on cream/white.
- The two sets depict ten corresponding characters, but **matching filename suffix numbers do not identify matching robots**. Use the explicit pairs below. The source drawings also have visible line-treatment differences; do not treat one file as a programmatically invertible copy of another.
- Latest user direction: vary the robots across the interface and select an existing variant suited to its actual background. Do not repeat one mascot everywhere.

The audit IDs below are inventory references for this source snapshot, not learning-content/database IDs. Paths are relative to the repository root. Full hashes, byte sizes, and exact opaque/partial/transparent pixel counts are in `docs/asset_inventory.json`.

## Original files

| Audit ID | Exact source path | Character | Surface |
|---|---|---|---|
| asset-01 | `Robot images/ChatGPT Image Oct 16, 2026, 05_06_20 PM-1.png` | Tracked robot, square head, uneven eyes, toothy grin | White/light panel; opaque |
| asset-02 | `Robot images/ChatGPT Image Oct 16, 2026, 05_06_20 PM-2.png` | Very tall thin robot, small round head, bent antenna | White/light panel; opaque |
| asset-03 | `Robot images/ChatGPT Image Oct 16, 2026, 05_06_21 PM-3.png` | Round head, twin antennae, large eyes, two wheels | White/light panel; opaque |
| asset-04 | `Robot images/ChatGPT Image Oct 16, 2026, 05_06_22 PM-4.png` | Squared head, asymmetric stern eyes, vertical grille mouth | White/light panel; opaque |
| asset-05 | `Robot images/ChatGPT Image Oct 16, 2026, 05_06_23 PM-5.png` | Waving claw, tilted rectangular head, curved antenna, round body | White/light panel; opaque |
| asset-06 | `Robot images/ChatGPT Image Oct 16, 2026, 05_06_24 PM-6.png` | Goggle eyes, articulated body, large boots | White/light panel; opaque |
| asset-07 | `Robot images/ChatGPT Image Oct 16, 2026, 05_06_25 PM-7.png` | Wide toaster-shaped body, twin antennae, zigzag mouth | White/light panel; opaque |
| asset-08 | `Robot images/ChatGPT Image Oct 16, 2026, 05_06_26 PM-8.png` | Rounded tilted head, curved antenna, spring legs | White/light panel; opaque |
| asset-09 | `Robot images/ChatGPT Image Oct 16, 2026, 05_06_27 PM-9.png` | Orb head with horizontal seam, dot eyes, three chest dots | White/light panel; opaque |
| asset-10 | `Robot images/ChatGPT Image Oct 16, 2026, 05_06_28 PM-10.png` | Tall rectangular head, grille smile, hovering saucer base | White/light panel; opaque |
| asset-11 | `Robot images/ChatGPT Image Oct 16, 2026, 06_17_48 PM-1.png` | Wide toaster-shaped robot | Dark/navy; transparent |
| asset-12 | `Robot images/ChatGPT Image Oct 16, 2026, 06_17_49 PM-2.png` | Spring-legged robot | Dark/navy; transparent |
| asset-13 | `Robot images/ChatGPT Image Oct 16, 2026, 06_17_51 PM-3.png` | Orb-head robot | Dark/navy; transparent |
| asset-14 | `Robot images/ChatGPT Image Oct 16, 2026, 06_17_52 PM-4.png` | Hover-saucer robot | Dark/navy; transparent |
| asset-15 | `Robot images/ChatGPT Image Oct 16, 2026, 06_17_53 PM-5.png` | Goggle-eyed robot | Dark/navy; transparent |
| asset-16 | `Robot images/ChatGPT Image Oct 16, 2026, 06_17_54 PM-6.png` | Waving robot | Dark/navy; transparent |
| asset-17 | `Robot images/ChatGPT Image Oct 16, 2026, 06_17_55 PM-7.png` | Round twin-antenna wheeled robot | Dark/navy; transparent |
| asset-18 | `Robot images/ChatGPT Image Oct 16, 2026, 06_17_56 PM-8.png` | Square-head grille-mouth robot | Dark/navy; transparent |
| asset-19 | `Robot images/ChatGPT Image Oct 16, 2026, 06_17_58 PM-9.png` | Tracked grinning robot | Dark/navy; transparent |
| asset-20 | `Robot images/ChatGPT Image Oct 16, 2026, 06_17_59 PM-10.png` | Tall thin robot | Dark/navy; transparent |

## Explicit character pairs

These identifiers describe the artwork and are not invented character names or personalities.

| Character key | Light-surface source | Dark-surface source |
|---|---|---|
| tracked | asset-01 | asset-19 |
| tall | asset-02 | asset-20 |
| round-wheels | asset-03 | asset-17 |
| grille | asset-04 | asset-18 |
| waving | asset-05 | asset-16 |
| goggles | asset-06 | asset-15 |
| wide | asset-07 | asset-11 |
| springs | asset-08 | asset-12 |
| orb | asset-09 | asset-13 |
| hover | asset-10 | asset-14 |

## Screen assignments and restraint

The following are planned stable assignments, not a claim that the screens have been implemented. Choose the light/dark source from the pair according to the mascot's **local surface**, rather than the application theme name alone. For example, a dark sidebar within a light app still needs the white-outline source. A light card within a dark app needs the black-outline source.

| Screen or flow | Planned character(s) | Reason / presentation rule |
|---|---|---|
| Local profile entry | waving | Welcoming original pose; one small companion beside the form |
| Home | tracked | Distinct anchor for returning learners; no additional robot beside every statistic |
| Vocabulary landing | hover for Learn; orb for Review; goggles for Master | Matches the distinct characters on slide 15's three cards while using supplied original poses; never add slide-specific books or altered limbs |
| Learn / Upcoming Words | wide | Matches slide 16's table companion; keep table rows and inputs clear |
| Vocabulary Review | tracked | Corresponds to slide 17's practice companion; omit the source's additional repeated table/panel robots |
| Mastered vocabulary | tall | Preserves slide 18's main original robot identity; white-outline version may sit on a small navy/evening accent |
| Word introduction | springs | Uses another supplied character for variety instead of repeating slide 18's tall robot; one small accent outside the five examples |
| Meaning / Hanzi–Pinyin recognition | round-wheels | Stable companion across this short quiz sequence; do not swap artwork randomly after each answer |
| Audio recognition / sentence ordering | grille | Distinct supporting character; no mouth/pose modification or simulated speaking animation |
| Foundation / productive sentence form | orb | Restrained guide; hide decoration if needed to preserve readable inputs |
| Grammar landing / details | goggles | Retains slide 26's first chapter companion; varying lesson content supplies variety without duplicating decorative robots on every row |
| Tutorial overlays | no extra mascot by default | Spotlight the real target component and keep Back/Next/Close readable |
| Top-level Practice / Speaking | none assigned | Design pending; do not imply a completed feature through elaborate mascot scenes |

Slide 19 and slides 20–25 repeatedly use a tall robot in the storyboard. The latest explicit request for variety supports assigning other **existing, untouched** originals to some of these screens. These assignments are an intentional design choice, not a convenience substitution. The original source character inventory remains available so future screen work can revisit a specific assignment against its notes.

## Usage contract

### Bundled welcome scaffold copies

These two files are now referenced by `pubspec.yaml` and `lib/shared/robot_art.dart`. They are byte-for-byte copies of two distinct characters; originals remain in place. Runtime layout is still unverified because Flutter is unavailable.

| Bundled path | Source ID | Actual scaffold surface | SHA-256 |
|---|---|---|---|
| `assets/mascots/welcome_waving_light.png` | asset-05 | White welcome card | `41fcddac8bc2725a7cc93bfe8a0840de14716e99bbb595154e7d980441352005` |
| `assets/mascots/welcome_orb_dark.png` | asset-13 | Navy companion card | `83a6f46bd0475921c1983bcdda2aea226f72edb63968656367758f1795fad090` |

### Preservation rules

1. Bundle only required assets as byte-for-byte copies and record both source and bundled path plus matching hash, as above. Do not rename or move the originals.
2. Preserve the entire source image, proportions, antennae, mouth, body, outlines, and transparent edges. Use aspect-preserving containment; never stretch, crop away limbs, tint, invert, recolor, regenerate, or combine parts.
3. The opaque white backgrounds are a source property. Place them within deliberate white illustration panels. Background removal is not authorized by this audit and was not attempted; it is unnecessary for the planned white surfaces.
4. Choose illustration dimensions according to content space. At narrow windows or large text scale, reduce or hide decoration rather than compressing forms, Chinese text, or controls.
5. Decorative mascots should be excluded from the accessibility tree. If a robot conveys actual instructional information, provide the information as accessible text; never make color or expression the sole signal.
6. Keep screen assignments stable and varied. Theme changes select a corresponding supplied variant, not a different character. Avoid placing the same robot repeatedly in a single view.
7. No generated pose, costume, altered book-holding variation, or PowerPoint screenshot is a substitute for these originals. No illustration or audio licensing claim is inferred from the slide deck.

## Reproducible audit and checks

Run from the repository root in Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\audit_assets.ps1
```

The script opens PNGs using System.Drawing, counts alpha states, writes `docs/asset_inventory.json`, and creates read-only visual-review contact-sheet derivatives under the operating system temp directory (`nihao-robot-asset-audit`). It does not edit source files. Each image is shown against cream and navy to expose contrast/transparency differences. Contact sheets are inspection artifacts, not app artwork.

Executed on 2026-11-03:

- Audit script: PASS; 20 images decoded and inventoried.
- Visual inspection: PASS; all 20 images reviewed on both surfaces, and all ten pairings identified by appearance.
- Integrity check: PASS; all 20 current source hashes match the inventory after preview generation.
- Alpha totals: PASS; transparent + partial-alpha + opaque pixels equal 1254 × 1254 for every file.
- Duplicate-byte check: PASS; 20 distinct hashes. Corresponding theme variants remain separate originals.
- In-app contrast, responsive sizing, and screen composition: NOT RUN; no executable Flutter environment was available for this audit.

No required robot file is missing. Transparent black-outline variants are not supplied; this is a known presentation constraint, not a blocker for white illustration panels.
