# Native Windows smoke test

## Queue and full curriculum acceptance - 2026-11-07

Windows debug build PASS in 275.1 seconds; seed checksum, all 4,118 audio hashes and audio plugin DLL verified. Use the newest build path recorded in PROJECT_MEMORY.md. Full native interaction/listening checks for this revision are NOT RUN; automated tests and widget screenshots do not replace them.

1. Close the existing app and make the documented database backup before schema-v5 migration.
2. Open Vocabulary > Browse words; allow the initial curriculum install to finish. Confirm 20 words and basic-first ordering. See 20 more must increase the count to 40.
3. Select a lower row, verify its highlight and Learn label, move it to front, and restart. Order must persist. A second profile must retain its own order. Restore priority order must preserve learning records.
4. Search for a word outside the first page, learn it and complete its seven/eight questions. Confirm it leaves the new-word queue and appears in scheduled review. Check a word with no examples still explains the gap and opens its quiz.
5. Play several linked sentence recordings, change clips and enter a quiz. Check stopping/retry/device errors. Use a Chinese IME for typed answers and test a narrow window/large text.
6. Reopen and compare old attempts, due dates and settings with the backup. Never launch an older executable against the migrated database.
7. Independently review sentence sense matching, distractor ambiguity and audio/text alignment before public release.

## Current content/audio acceptance — 2026-11-06

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
| Create profile `Smoke A`: 10 minutes, Travel, Pinyin off | Picker shows saved settings and selected profile | NOT RUN |
| Continue; start introduction; advance to step 3; Save and leave | Home offers resume at step 3 | NOT RUN |
| Switch; create `Smoke B` with default settings | B starts at step 1; A's position stays independent | NOT RUN |
| Select A; close the entire app; relaunch the same executable offline | A remains selected with its settings; introduction resumes at step 3 | NOT RUN |
| Complete A's introduction, replay, then leave early | Completion remains recorded; no word or mastery credit appears | NOT RUN |
| With A, inspect character page, Pinyin page and tone page | Optional Pinyin is hidden; teaching examples remain visible; audio is explicitly unavailable | NOT RUN |
| Replay Home, Vocabulary and Grammar tutorials | Live targets highlighted; Back, Next, Done and Close work; Enter/Escape work | NOT RUN |
| Open Vocabulary | Three distinct original robots; Browse words and Open reviews work; Master is pending | NOT RUN |
| Browse words; explore 你好 | Exactly five examples, visible pilot/teacher-review notice, profile Pinyin preference, audio unavailable | NOT RUN |
| Continue to Quiz; answer both questions; save | One saved result, explanatory feedback and a five-minute due date; no mastery | NOT RUN |
| Open reviews before and at the due time | Not due yet initially; Review now becomes available at due time | NOT RUN |
| Submit an incorrect due review, close the entire app, relaunch offline | Relearning and its five-minute due date persist; profile selection remains intact | NOT RUN |
| Complete a correct due review | Next review is one day later; successful delayed-review count increases once | NOT RUN |
| Switch to B and open reviews | A's word does not appear in B's list | NOT RUN |
| Open primary Practice and Speaking | Both say Coming later — design pending | NOT RUN |
| Resize to approximately 1440×900, 900×700 and 360×640 | Scroll/navigation remain usable; no clipped controls or overflow | NOT RUN |
| Increase Windows text scaling to 200%, then restore its prior value | Introduction and tutorial actions remain reachable | NOT RUN |
| Return to profile B after completing A | B remains uncompleted at its own saved position | NOT RUN |

## Record after execution

Record date, source commit, executable path, Windows version, Flutter doctor/build result and each failure's reproduction steps. Record actual observations rather than marking the whole checklist passed after launch alone. Use only disposable names in screenshots. If any persistence check fails, preserve the database and report the mismatch; do not reset it and retry as a fresh install.
