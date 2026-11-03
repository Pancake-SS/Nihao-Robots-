# Development setup

Observed on 2026-11-03: the workspace initially had only the starter documents/scripts and robot images. Flutter and Dart were absent from PATH and checked common SDK locations. No application build, package resolution or Flutter test was possible. Windows runner files and `pubspec.lock` are intentionally not fabricated.

## Install and verify Flutter

Use the official [Flutter installation instructions](https://docs.flutter.dev/install/with-vs-code) and [Windows desktop setup](https://docs.flutter.dev/platform-integration/windows/setup). Windows native builds require Visual Studio's **Desktop development with C++** workload; VS Code alone does not supply the compiler. Keep Flutter in a writable SDK location, outside this repository. Reopen the terminal after updating PATH.

From the project root in PowerShell:

```powershell
flutter --version
dart --version
flutter doctor -v
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\bootstrap_windows.ps1
flutter pub get
dart format lib test
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter run -d windows
```

Resolve doctor errors for the Windows toolchain. The bootstrap script generates a temporary SDK app and copies only its missing Windows runner and metadata; it refuses to overwrite an existing runner or metadata. It does not replace this project's `lib/`, tests, assets, README or `pubspec.yaml`. Flutter package resolution creates the real lockfile; commit it with the verified SDK version. Use the formatter's write command once before the mandatory no-change gate, since formatting could not run in this environment.

This starts only the welcome scaffold. It has no local profiles, learning database, tutorial, quiz or saved progress yet. No web server is needed.

## Next dependency gate

The approved architecture remains Riverpod + Drift/SQLite. Add them when implementing profile persistence, after the SDK passes doctor. Check current publisher docs, platform support and licenses; resolve compatible versions with this SDK and commit the lockfile. Do not use unconstrained `any`, invent a lockfile, or create generated Drift code by hand. Useful official references: [Riverpod](https://pub.dev/packages/flutter_riverpod), [Drift](https://pub.dev/packages/drift), [Drift setup](https://drift.simonbinder.eu/setup/).

Profile slice acceptance: two offline profiles, validated names/settings, select/continue after restart, isolated data, visible loading/save-error states and meaningful repository/database/widget tests. Add only tables needed for that slice. Subsequent learning work adds immutable deduplicated events and transactional scheduling with an injected clock.

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
