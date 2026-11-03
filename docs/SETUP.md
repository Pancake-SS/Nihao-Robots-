# Development setup

Updated 2026-11-04. Flutter 3.47.9 / Dart 3.13.7 are now installed from the official stable repository at `%TEMP%\nihao-tools\flutter`; the resolved Pub cache is `%TEMP%\nihao-tools\pub-cache`. The source includes a generated Windows runner, generated Drift code and real `pubspec.lock`. The local-profile slice runs in the Flutter test harness; native launch has additional prerequisites below.

## Use the portable SDK

`scripts/flutter.ps1` uses `NIHAO_FLUTTER_ROOT` when supplied, an SDK on PATH, or the portable SDK above. It never edits global/user PATH. Temp directories can be cleaned by Windows; for a permanent install follow the official [Flutter installation instructions](https://docs.flutter.dev/install/with-vs-code), then point `NIHAO_FLUTTER_ROOT` to that SDK or put it on PATH.

From the project root in PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\flutter.ps1 --version
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\flutter.ps1 doctor -v
$dartTool = Join-Path $env:TEMP 'nihao-tools\flutter\bin\dart.bat'
& $dartTool format --output=none --set-exit-if-changed .
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\flutter.ps1 analyze --no-pub
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\flutter.ps1 test --no-pub
```

`--no-pub` uses the already-resolved dependencies and avoids repeating native plugin symlink setup. On a fresh machine run `flutter pub get` after enabling Windows Developer Mode. For a different SDK, adjust the Dart executable path. Do not rerun `bootstrap_windows.ps1` on the current project: its runner and metadata already exist, and the script correctly refuses to overwrite them.

## Native Windows launch

Follow the official [Windows desktop setup](https://docs.flutter.dev/platform-integration/windows/setup): install Visual Studio with **Desktop development with C++** and its default components. VS Code alone does not include this compiler. Enable **Developer Mode** in Windows Settings so Flutter can create native-plugin symlinks. Both were missing in the last environment checks; these machine settings were not changed automatically.

Flutter's native builder also rejects the `!` in this workspace's name. Keep the workspace in place and use the safe-path staging helper:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build_windows.ps1
```

The helper copies only `lib`, `assets`, `windows`, `pubspec.yaml`, `pubspec.lock` and `.metadata` to a new `%TEMP%\nihao-windows-...` directory, resolves packages there and builds a debug executable. It prints the executable path on success. It does not copy learner data, the reference deck, source robot inventory, `.git`, `.venv` or editor settings. The source snapshot is retained for inspection; subsequent edits require a new build. Use `-Configuration release` for a release build only after native smoke tests pass.

The implemented flow is Create Local Profile → Choose → Continue → Home → Introduction → Save/Resume/Replay. Home, Vocabulary and Grammar have contextual tours; Practice/Speaking remain design-pending. Profile settings, last selection and per-profile introduction state persist in SQLite. Vocabulary/grammar lessons, quizzes, audio and learning metrics remain pending. No web server is needed.

## Dependencies, code generation and data preservation

Riverpod/Drift are resolved and tested; see `docs/DEPENDENCIES.md` and `pubspec.lock`. Do not hand-edit `lib/data/app_database.g.dart`. To regenerate or export schema after an intentional change:

```powershell
$env:PUB_CACHE = Join-Path $env:TEMP 'nihao-tools\pub-cache'
$dartTool = Join-Path $env:TEMP 'nihao-tools\flutter\bin\dart.bat'
& $dartTool run build_runner build
& $dartTool run drift_dev schema dump lib\data\app_database.dart docs\schema\drift_schema_v2.json
& $dartTool format lib test scripts\preview_profiles.dart
```

Schema v1 is the retained baseline; v2 adds introduction state through a tested additive migration. For later versions, use a new export filename and implement/test migration; never overwrite historical schemas. Read [migration and backup recovery](MIGRATIONS.md) before updating a real installation. The database is `ni_hao_robot.sqlite` under the OS app-support directory. Windows company/product metadata influences that directory: changing it requires a data-path migration. Unknown upgrades fail rather than dropping tables. Keep real databases intact; never use test reset logic on learner storage.

Profile acceptance tests cover independent same-name profiles, invalid inputs, write rollback, persistent selection, temporary SQLite file reopening, and a UI-created profile continued after database/widget restart. Full native process testing is still a separate gate. Optional visual review: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\flutter.ps1 test --no-pub scripts\preview_profiles.dart`; PNGs go to `%TEMP%\nihao-profile-previews`.

## Documentation tools

Development tools are separate from application dependencies. A working local Python 3.13 was found at `C:\Users\User\AppData\Local\Programs\Python\Python313\python.exe`; the Store alias/launcher failed inside the sandbox. A project `.venv/` was created and is ignored by Git. On another machine, use your installed Python:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r scripts\requirements-docs.txt
.\.venv\Scripts\python.exe scripts\sync_journal.py
.\.venv\Scripts\python.exe -m unittest discover -s scripts -p 'test_*.py' -v
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit_assets.ps1
.\.venv\Scripts\python.exe scripts\audit_presentation.py 'reference\Copy of MCPKI_FYP_Starred_Slides_Updated.pptx.pptx' --output "$env:TEMP\nihao-slide-audit\audit.json"
```

Update `docs/PROJECT_MEMORY.md` first; the Word file is its generated mirror. The journal script uses an atomic replacement to preserve an existing journal when generation fails. LibreOffice is needed for the skill's canonical DOCX visual renderer. It was absent here; the Word fallback did not render successfully, so final journal layout remains visually unverified. The PPTX was independently rendered with installed PowerPoint, opened read-only without a visible presentation window.

The original PPTX stays local and outside Git because it contains illustrative credentials. Do not copy those values into code, curriculum, logs or reports. Do not commit `.venv`, learner databases, secrets or generated QA images.
