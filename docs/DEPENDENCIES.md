# Profile slice dependency record

Recorded 2026-11-04; resolution and package/advisory checks performed 2026-11-03. Exact transitive versions and package archive checksums are in `pubspec.lock`.

- Flutter 3.47.9, official stable revision `c197ca5199e9ee5661e865596c9c07294dfab51c`; Dart 3.13.7.
- Runtime: flutter_riverpod 3.4.3, drift 2.35.3, drift_flutter 0.3.1, path_provider 2.1.6, path 1.9.1 and characters 1.4.1.
- Development generators: drift_dev 2.35.2 and build_runner 2.17.1. SQLite binding resolved transitively to sqlite3 3.8.0.
- Direct package license files reviewed: Riverpod, Drift, drift_flutter and drift_dev use MIT; path_provider, path, characters and build_runner use BSD-style redistribution terms. sqlite3 uses MIT. Retain notices when distributing; Flutter's generated license bundle is not a substitute for reviewing any future bundled content/audio rights.
- Package/platform suitability checked against [Riverpod package documentation](https://pub.dev/packages/flutter_riverpod), [Drift setup](https://drift.simonbinder.eu/setup/) and [drift_flutter](https://pub.dev/packages/drift_flutter). The native opener uses app support rather than the helper's default documents location.
- Queried all **93 hosted Pub package/version pairs** in the lockfile using [OSV's batch advisory API](https://google.github.io/osv.dev/post-v1-querybatch/): 93 results, no matching advisories returned. This is a dated database check, not a guarantee that packages or native binaries have no vulnerabilities.
- drift_flutter currently brings the publisher's end-of-life compatibility packages `sqlite3_flutter_libs` and `sqlcipher_flutter_libs` transitively. No encryption feature or deprecated direct API was adopted. Recheck the native packaging path when Windows compilation becomes available; do not arbitrarily override transitive versions.

Core profile creation, selection and persistence have no network dependency. SDK/package downloads, code generation and advisory queries are development-only operations.
