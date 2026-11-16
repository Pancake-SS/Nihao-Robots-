# Grammar lessons

The Grammar tab has two profile-specific lists: **Pending** and **Completed**. A lesson can be opened from either list. Marking a lesson completed moves it to Completed; moving it back restores it to Pending. This is a study marker, with no quiz, wait timer, or mastery threshold. Search, HSK level and category filters apply within either list. Lists show 20 lessons at a time.

The bundled offline pack contains 428 grammar points from the user-provided `reference/hsk-3.0-complete.json`. Each point has its HSK level, category, explanation, structure when supplied, and a Chinese/English example. The first twelve lessons prioritize common beginner sentence patterns; the remaining points follow HSK level and source order. The original source is attributed to Gushi under CC BY-SA 4.0. Its SHA-256 is `01fcee191c76ddcda96a42dff23106b70a19ab39ae288974c4e04956bf533a67`.

Nineteen carefully matched lessons also have short teaching notes and examples from the [AllSet Learning Chinese Grammar Wiki copy](https://github.com/ivankra/asg). That source is CC BY-NC-SA 3.0. Each enriched lesson displays the source name, license and article URL. The pack contains 464 examples overall. The remaining lessons use their source explanations and examples; no automatic semantic match or AI-generated explanation is claimed. The source examples have no Pinyin, so Pinyin appears only for the AllSet examples that provide it. Each example has a Mandarin speech button, using the device's Chinese TTS voice.

The bundled asset `assets/content/grammar_v1.json` is generated from the original JSON and a local copy of `ivankra/asg`. To rebuild it after an intentional source or mapping change:

```powershell
python scripts/build_grammar.py --wiki C:\path\to\asg\wiki
```

Review the manual `ASG` crosswalk in `scripts/build_grammar.py` before changing it. A content change requires an incremented pack revision because the installer rejects a changed digest at the same revision. The installer validates all 428 records, stable IDs and example links, then writes the pack and revision marker in one database transaction. `grammar_lessons` and `grammar_examples` hold shared content; `grammar_progress` holds profile-specific completion with a foreign key to the lesson. Reinstalling a newer revision preserves valid profile completion rows.

The short examples and notes are for local study. They have not received independent teacher review. License and source notices are also shipped in `assets/content/GRAMMAR_ATTRIBUTION.txt`.
