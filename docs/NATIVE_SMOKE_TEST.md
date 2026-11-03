# Native Windows smoke test

Prepared 2026-11-04 for checkpoint `19afc03`. Status: NOT RUN. Flutter widget tests are not a substitute for this checklist.

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
| Open Vocabulary | Three distinct original robots; pending activities honestly labeled | NOT RUN |
| Open primary Practice and Speaking | Both say Coming later — design pending | NOT RUN |
| Resize to approximately 1440×900, 900×700 and 360×640 | Scroll/navigation remain usable; no clipped controls or overflow | NOT RUN |
| Increase Windows text scaling to 200%, then restore its prior value | Introduction and tutorial actions remain reachable | NOT RUN |
| Return to profile B after completing A | B remains uncompleted at its own saved position | NOT RUN |

## Record after execution

Record date, source commit, executable path, Windows version, Flutter doctor/build result and each failure's reproduction steps. Record actual observations rather than marking the whole checklist passed after launch alone. Use only disposable names in screenshots. If any persistence check fails, preserve the database and report the mismatch; do not reset it and retry as a fresh install.
