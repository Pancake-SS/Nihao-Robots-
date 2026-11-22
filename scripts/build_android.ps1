# Build a local-install Android APK with the shared Ni Hao Robot! launcher icon.
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$apkPath = Join-Path $projectRoot 'build\app\outputs\flutter-apk\app-release.apk'

Push-Location -LiteralPath $projectRoot
try {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'generate_android_icons.ps1')
    if ($LASTEXITCODE -ne 0) { throw 'Could not prepare Android launcher icons.' }

    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'flutter.ps1') pub get --enforce-lockfile
    if ($LASTEXITCODE -ne 0) { throw 'Could not resolve pinned Flutter packages.' }

    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'flutter.ps1') build apk --release --no-pub
    if ($LASTEXITCODE -ne 0) { throw 'Android APK build failed.' }

    if (-not (Test-Path -LiteralPath $apkPath)) { throw 'Flutter reported success but the APK is missing.' }
    $apk = Get-Item -LiteralPath $apkPath
    Write-Output "Android APK: $($apk.FullName) ($([Math]::Round($apk.Length / 1MB, 1)) MB)"
} finally {
    Pop-Location
}
