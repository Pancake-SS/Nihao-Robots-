# Native Windows smoke test

## Historical word/example TTS checkpoint - 2026-11-07

Native build PASS in 176.1 seconds; compiled curriculum, original recordings and both speech/audio DLLs verified. Windows Mandarin voice installation is still downloading at this checkpoint, so native audible TTS acceptance remains NOT RUN. See SETUP.md for the latest executable and installer status file.

1. Use the latest build containing flutter_tts and curriculum revision 2; older builds lack these changes.
2. In a lesson, Play word should use a Mandarin voice. Confirm generated speech against displayed Pinyin, especially polyphonic words. No English default should be used.
3. Existing recorded examples should retain Play sentence. Missing recordings should show Read sentence; starting either should stop the previous recording/TTS. Stop, route exit and Continue to Quiz must stop speech.
4. With no offline Mandarin voice, verify the explicit setup/retry message. After installing a voice, retry without resetting learner data.
5. Inspect a supplemental Tatoeba example: source and translation URLs, credits and Pinyin annotation notes must be present. All old recordings and progress should survive the curriculum update.

Native audible listening is still manual; successful compilation or generating a speech stream does not establish pronunciation quality.

## Historical queue acceptance - 2026-11-07

Windows debug build PASS in 275.1 seconds; seed checksum, all 4,118 audio hashes and audio plugin DLL verified. Use the newest build path recorded in PROJECT_MEMORY.md. Full native interaction/listening checks for this revision are NOT RUN; automated tests and widget screenshots do not replace them.

1. Close the existing app and make the documented database backup before the current schema-v6 migration.
2. Open Vocabulary > Browse words; allow the initial curriculum install to finish. Confirm 20 words and basic-first ordering. See 20 more must increase the count to 40.
3. Select a lower row, verify its highlight and Learn label, move it to front, and restart. Order must persist. A second profile must retain its own order. Restore priority order must preserve learning records.
4. Search for a word outside the first page, learn it and complete its seven/eight questions. Confirm it leaves the new-word queue and appears in scheduled review. Check a word with no examples still explains the gap and opens its quiz.
5. Play several linked sentence recordings, change clips and enter a quiz. Check stopping/retry/device errors. Use a Chinese IME for typed answers and test a narrow window/large text.
6. Reopen and compare old attempts, due dates and settings with the backup. Never launch an older executable against the migrated database.
7. Independently review sentence sense matching, distractor ambiguity and audio/text alignment before public release.

## Historical content/audio acceptance — 2026-11-06

The previous successful native launch below predates schema v4 and the audio plugin. Current debug build: **PASS**, 113.9 seconds, including the audio plugin. Output: `%TEMP%/nihao-windows-c741e0edd7ac498080d9f69606a184c0/build/windows/x64/runner/Debug/ni_hao_robot.exe`. Its dictionary, lesson packs, attribution and all 88 MP3 hashes match source. Full functional/native playback checks for this checkpoint remain **NOT RUN** until explicitly recorded.

1. Close the old app and back up its database as described in MIGRATIONS.md; preserve old attempt counts and due dates.
2. Build the current source using `scripts\build_windows.ps1`, then open its printed executable.
3. Browse the 21 lessons and open the full 11,147-word library; check Start here → Beginner → Intermediate → Advanced ordering and the separate Unranked filter. Then return to lessons; search `书`, `shū`, `shu1` and `book`. Open 书 and inspect its five examples and source labels.
4. With network disconnected, play and stop sentence recordings; change clips, navigate back and enter the quiz during playback. Sound should stop appropriately. Check volume/device failures retain readable lessons and allow retry.
5. Complete all eight questions, including both Pinyin directions, cloze and a real Chinese IME typed answer. Verify wrong answers record relearning and no mastery; repeat at a smaller window/large text.
6. Close/reopen, confirm profiles, old two-question greeting snapshots, new attempts and due dates survive. Keep the updated database; never run the old executable against it.
7. Listen to all selected recordings during teacher review for pronunciation, text alignment and quality. File checksums and mock-player tests do not establish audible correctness.

## Historical schema-v3 launch record

Updated 2026-11-04 for the schema-v3 greeting pilot. Build and basic window launch: PASS. Functional checklist below: NOT RUN. Flutter widget tests are not a substitute for this checklist.

After restoring the temporary SDK's missing Dart runtime, Visual Studio Community 2026/C++ and Developer Mode passed setup checks. `scripts/build_windows.ps1` produced a debug executable in `%TEMP%/nihao-windows-b1b41107bbe24c7e9e9eaec40e8efc57/build/windows/x64/runner/Debug/ni_hao_robot.exe`. Build completed in 73 seconds with nonfatal MSB8029 warnings about temporary incremental-build directories. The native process remained running with window title `Ni Hao Robot!` and Responding=True. This verifies basic process/window startup only; no profile or learner-flow acceptance row is marked passed from that observation.

## Prerequisites and launch

1. Follow `SETUP.md`: enable Windows Developer Mode and install Visual Studio's Desktop development with C++ workload. These are machine prerequisites, not app dependencies.
2. If this machine has existing learner data, close the app and follow the backup instructions in `MIGRATIONS.md`. Never delete or reset that database for testing.
3. From the project root, run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\flutter.ps1 doctor -v
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build_windows.ps1
```

4. Launch the executable printed by the build helper. Use that same build for both launches below. The helper stages source outside the workspace because Flutter rejects its exclamation mark.
5. Once build dependencies are downloaded, disconnect the network for the app checks. Do not interrupt an active download or other work to do this.

## Checks and expected results

Use clearly named disposable profiles, keeping any existing profiles intact. There is currently no profile-delete feature; these test profiles will remain in the local installation.

| Check | Expected result | Result |
|---|---|---|
| Launch the packaged app with `scripts\run_windows.ps1` | The window opens with its DLLs/assets and stays responsive | PASS: 2026-11-18, title Ni Hao Robot!, responding after 12 seconds |
| Create profile `Smoke A`: 10 minutes, Travel, Pinyin off | Picker shows saved settings and selected profile | NOT RUN |
| Continue; start introduction; advance to step 3; Save and leave | Home offers resume at step 3 | NOT RUN |
| Switch; create `Smoke B` with default settings | B starts at step 1; A's position stays independent | NOT RUN |
| Select A; close the entire app; relaunch the same executable offline | A remains selected with its settings; introduction resumes at step 3 | NOT RUN |
| Complete A's introduction, replay, then leave early | Completion remains recorded; no word or mastery credit appears | NOT RUN |
| With A, inspect character page, Pinyin page and tone page | Optional Pinyin is hidden; teaching examples remain visible; audio is explicitly unavailable | NOT RUN |
| Replay Home, Vocabulary and Grammar tutorials | Live targets highlighted; Back, Next, Done and Close work; Enter/Escape work | NOT RUN |
| Open Vocabulary | Three distinct original robots; Browse words, Practice and Master open | NOT RUN |
| Open Grammar > Pending, then browse pages and filter by HSK level and category | Lessons appear 20 per page; beginner patterns are first; search finds Chinese or English text | NOT RUN |
| Open Learning > Explore online; filter by Read/Watch and level, then open a resource | The matching source site opens in the default browser; a failed launch shows a retryable message | NOT RUN |
| Open Learning > Classical stories; read a Baiyu parable, search for a Zhuangzi chapter, then open the pinned source | All three works load offline; Previous/Next and text size work; the source opens in a browser when online | NOT RUN |
| Open Learning > Free writing; change the topic, type with the Chinese keyboard and save | The chosen topic and text appear in saved writing after app restart, independently of Master writing | NOT RUN |
| Open Learning > Notebook; paste Chinese, add Pinyin/English notes, save, edit and delete | Text persists after scrolling/restart; Save stays visible; only the active profile can see the entry | NOT RUN |
| Open a grammar lesson and play its example speech | Explanation, structure when available, Chinese/English examples and source credit are readable; Mandarin speech plays if the installed voice is available | NOT RUN |
| Mark one grammar lesson completed, relaunch, switch profiles, then move it back to Pending | It appears only in the first profile’s Completed list after relaunch; the second profile retains its own Pending list; moving it back works | NOT RUN |
| Browse words; type Pinyin in search, choose Hanzi and explore 你好 | Search uses the chosen Hanzi; lesson has five examples, source details, Pinyin preference and word/example audio controls | NOT RUN |
| Continue to Quiz; answer questions and save | Wrong answers return at the end; first-try correct answers add correctness points; no due timer | NOT RUN |
| Open Practice immediately and replay the selected word's full test | Test starts without waiting; each correct first answer adds a point | NOT RUN |
| Start a numbered random session and an endless session | Numbered questions use different words; endless original questions do not repeat; wrong answers return at the end of each round | NOT RUN |
| Search by Hanzi or English and relearn, then close and relaunch offline | The matching lesson opens; correctness points and profile selection persist | NOT RUN |
| Switch to B and open Practice | A's learned word and correctness points do not appear in B's list | NOT RUN |
| Open Practice and choose each of its four methods | Each method opens its own page; one word, counted random, endless and relearn controls are clear | NOT RUN |
| Reach 25 correct points for a word, then open Vocabulary > Master | The word appears in Ready for Master test; passing the full quiz moves it straight into Master | NOT RUN |
| Select an unlearned word in Vocabulary > Learn and choose Instant master | A confirmation explains direct Master; Not now leaves the word untouched, while Master this word moves it to Master without a quiz | NOT RUN |
| Search a known word under Instant master | Confirming moves the word directly into Master without a quiz or writing prompt | NOT RUN |
| Practise a mastered word and miss three answers | It returns to Learn; correctness points remain available | NOT RUN |
| Open primary Practice and Speaking | Practice is usable; Speaking remains pending | NOT RUN |
| Resize to approximately 1440×900, 900×700 and 360×640 | Scroll/navigation remain usable; no clipped controls or overflow | NOT RUN |
| Increase Windows text scaling to 200%, then restore its prior value | Introduction and tutorial actions remain reachable | NOT RUN |
| Return to profile B after completing A | B remains uncompleted at its own saved position | NOT RUN |

## Record after execution

Record date, source commit, executable path, Windows version, Flutter doctor/build result and each failure's reproduction steps. Record actual observations rather than marking the whole checklist passed after launch alone. Use only disposable names in screenshots. If any persistence check fails, preserve the database and report the mismatch; do not reset it and retry as a fresh install.
