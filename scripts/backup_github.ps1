# Upload reviewed commits only. Never stages files, rewrites history or force-pushes.
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$expectedRemote = 'https://github.com/Pancake-SS/Nihao-Robots-.git'
$remote = & git -c "safe.directory=$projectRoot" -C $projectRoot remote get-url origin
if ($LASTEXITCODE -ne 0 -or $remote -ne $expectedRemote) {
    throw "Backup stopped: origin must be $expectedRemote"
}
$pushUrls = @(& git -c "safe.directory=$projectRoot" -C $projectRoot remote get-url --push --all origin)
if ($LASTEXITCODE -ne 0 -or $pushUrls.Count -ne 1 -or $pushUrls[0] -ne $expectedRemote) {
    throw "Backup stopped: origin must push only to $expectedRemote"
}
$branch = & git -c "safe.directory=$projectRoot" -C $projectRoot branch --show-current
if ($LASTEXITCODE -ne 0 -or $branch -ne 'main') {
    throw 'Backup stopped: switch to the reviewed main branch before running this helper.'
}
$changes = & git -c "safe.directory=$projectRoot" -C $projectRoot status --porcelain
if ($LASTEXITCODE -ne 0) { throw 'Could not inspect the working tree.' }
if ($changes) {
    Write-Warning 'Uncommitted changes remain local. Review and commit intended changes before backing them up.'
}
& git -c "safe.directory=$projectRoot" -C $projectRoot push --set-upstream origin HEAD:main
if ($LASTEXITCODE -ne 0) { throw 'Backup failed. Check authentication or remote changes; no force-push was attempted.' }
$localCommit = & git -c "safe.directory=$projectRoot" -C $projectRoot rev-parse HEAD
$remoteHead = & git -c "safe.directory=$projectRoot" -C $projectRoot ls-remote origin refs/heads/main
if ($LASTEXITCODE -ne 0 -or -not $remoteHead -or ($remoteHead -split '\s+')[0] -ne $localCommit) {
    throw 'Could not confirm that the GitHub branch matches this checkpoint.'
}
Write-Output "GitHub backup verified: $localCommit"
