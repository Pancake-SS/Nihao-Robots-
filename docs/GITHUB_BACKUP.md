# GitHub backup

Repository: https://github.com/Pancake-SS/Nihao-Robots-
Remote: `origin`, HTTPS URL `https://github.com/Pancake-SS/Nihao-Robots-.git`.
Local branch `main` tracks remote `main`. The first verified backup was checkpoint
`6dc050caf4f28f6a8532df03c02c71bdba62cb19` on 2026-11-10.

## Save a checkpoint

Review `git diff` and `git status`, stage only intended project changes, then commit.
Run `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\backup_github.ps1`.
The helper requires local `main`, checks both fetch and push URLs, pushes `HEAD`
to `origin/main` without force, and compares the remote
commit to the local checkpoint. A remote mismatch, failed push or authentication
problem produces an error. Fetch and reconcile remote edits before trying again;
never replace remote history to bypass a rejection.

The helper never auto-stages, auto-commits or uploads uncommitted edits. It warns
when edits remain local. No scheduled/background upload task is installed.
The existing Windows Git Credential Manager account authenticates the push;
no access token is saved in this repository or its remote URL.

## Included and excluded

Tracked source, licensed content/audio, artwork, documentation and full committed
history are included. `.gitignore` excludes local learner databases, credentials,
SDK/dependency caches, temporary imports, generated builds and the original PPTX
(which contains illustrative sign-in credentials). The pre-existing local deletion
of START_HERE.md remains uncommitted; it is not silently staged by the helper.

A Nov 10 pre-upload audit checked tracked/history paths, 300 text blobs for common
credential patterns and historical file sizes. No matching credentials or tracked
private-data paths were found. This is a bounded scan, not a guarantee that every
possible secret format can be detected. The largest curriculum blob is 99.68 MiB;
GitHub accepted it with a size recommendation warning. Further curriculum growth
will need a separate asset/storage strategy before exceeding the upload limit.

## Restore the project

Clone `https://github.com/Pancake-SS/Nihao-Robots-.git`, then follow SETUP.md to
install Flutter/Windows prerequisites and build the app. Bundled curriculum and
recordings are included; raw import caches can be fetched from pinned source locks
if rebuilding content is needed. Learner profiles/progress require a separate
closed-database backup; they are intentionally not stored on GitHub.
