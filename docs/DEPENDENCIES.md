# Application dependency record

## External resource links - 2026-11-18

Added `url_launcher 6.3.3` from the verified Flutter publisher (BSD-style license, installed notice inspected). The resolved Windows adapter is `url_launcher_windows 3.1.6`; exact hashes and other platform adapters are in `pubspec.lock`. The [official package page](https://pub.dev/packages/url_launcher) documents Windows support and opening links in the default browser. Only a learner's explicit **Open site** action launches a browser; the app does not stream, scrape or download third-party media in the background.

## Device speech and corpus annotation - 2026-11-07

Added pinned `flutter_tts 4.2.5` (MIT, Daniel Lutton); installed source/license inspected. It supports Windows speech/voice selection using the native speech engine. Existing resolved versions are unchanged. [Official package documentation](https://pub.dev/packages/flutter_tts) and its Windows implementation were reviewed; use explicit voice selection because language-only selection can silently retain a default voice. The app filters for offline Mandarin locales.

Import-only Python dependencies are pinned in `scripts/requirements-content.txt`: pypinyin 0.55.0 (MIT) and opencc-python-reimplemented 0.1.7 (Apache license). They annotate Pinyin and match original Traditional Chinese sentence IDs to Simplified corpus text. Python is not required by the distributed app. OSV batch queries for these three exact new package/version pairs on 2026-11-07 returned three results with no matching advisories. This is a dated check, not a security guarantee.

## Curriculum checksums - 2026-11-07

`crypto 3.0.8` is now a pinned direct dependency for verifying the bundled curriculum SHA-256. It was already resolved transitively at this exact version; no package versions changed. The previous dated advisory review below is not a new scan. No runtime network service was added.

## Sentence audio checkpoint — 2026-11-06

Added pinned `audioplayers 6.8.1`, with `audioplayers_windows 4.4.1`. The [official package documentation](https://pub.dev/packages/audioplayers) documents Windows asset playback. The native adapter uses local bundled paths and is created lazily when playback is requested. No microphone permission or streaming endpoint is introduced.

Resolved adapters: android 5.3.0, darwin 6.5.0, linux 4.3.0, platform_interface 7.2.0, web 5.3.0, windows 4.4.1. Additional hosted dependencies: http 1.6.0 and synchronized 3.6.1; flutter_web_plugins comes from the SDK. Installed license files reviewed: audioplayers adapters and synchronized use MIT; http uses BSD-style terms. Code licenses are separate from recording/data attribution.

Queried OSV on 2026-11-06 for all **102 hosted package/version pairs** in the current lockfile: 102 results, no matching advisories returned. This is a dated lookup, not an absence-of-vulnerabilities guarantee. Versions/checksums remain in `pubspec.lock`.

## Earlier profile slice record

Recorded 2026-11-04; resolution and package/advisory checks performed 2026-11-03. Exact transitive versions and package archive checksums are in `pubspec.lock`.

- Flutter 3.47.9, official stable revision `c197ca5199e9ee5661e865596c9c07294dfab51c`; Dart 3.13.7.
- Runtime: flutter_riverpod 3.4.3, drift 2.35.3, drift_flutter 0.3.1, path_provider 2.1.6, path 1.9.1 and characters 1.4.1.
- Development generators: drift_dev 2.35.2 and build_runner 2.17.1. SQLite binding resolved transitively to sqlite3 3.8.0.
- Direct package license files reviewed: Riverpod, Drift, drift_flutter and drift_dev use MIT; path_provider, path, characters and build_runner use BSD-style redistribution terms. sqlite3 uses MIT. Retain notices when distributing; Flutter's generated license bundle is not a substitute for reviewing any future bundled content/audio rights.
- Package/platform suitability checked against [Riverpod package documentation](https://pub.dev/packages/flutter_riverpod), [Drift setup](https://drift.simonbinder.eu/setup/) and [drift_flutter](https://pub.dev/packages/drift_flutter). The native opener uses app support rather than the helper's default documents location.
- Queried all **93 hosted Pub package/version pairs** in the lockfile using [OSV's batch advisory API](https://google.github.io/osv.dev/post-v1-querybatch/): 93 results, no matching advisories returned. This is a dated database check, not a guarantee that packages or native binaries have no vulnerabilities.
- drift_flutter currently brings the publisher's end-of-life compatibility packages `sqlite3_flutter_libs` and `sqlcipher_flutter_libs` transitively. No encryption feature or deprecated direct API was adopted. Recheck the native packaging path when Windows compilation becomes available; do not arbitrarily override transitive versions.

Core profile creation, selection and persistence have no network dependency. SDK/package downloads, code generation and advisory queries are development-only operations.

Windows TTS build prerequisite: `ensure_nuget.ps1` installs official NuGet CLI 7.9.0 from the versioned dist.nuget.org URL into LocalAppData/NihaoRobotTools/nuget/7.9.0. Its Microsoft Authenticode signature and SHA-256 `992d70cac5b06c38efec91806caba64cdcc07e6d963a0959dbbbaf264d33b800` are checked. `build_windows.ps1` adds only this build process's PATH entry; user/machine PATH is unchanged. The pinned flutter_tts plugin restores Microsoft.Windows.CppWinRT 2.0.210503.1 during CMake configuration. These are build tools, not runtime network dependencies.
