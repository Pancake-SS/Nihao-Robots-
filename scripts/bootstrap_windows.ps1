# Generate the Windows runner with the installed Flutter SDK, never by hand.
# Keep existing application sources and pubspec intact.
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$runner = Join-Path $projectRoot 'windows'
$metadata = Join-Path $projectRoot '.metadata'

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw 'Flutter is not on PATH. Install the SDK using docs/SETUP.md first.'
}
if ((Test-Path -LiteralPath $runner) -or (Test-Path -LiteralPath $metadata)) {
    throw 'A Windows runner or Flutter metadata already exists. Inspect it; this script never overwrites it.'
}

$scaffold = Join-Path ([System.IO.Path]::GetTempPath()) ('nihao-flutter-' + [guid]::NewGuid().ToString('N'))
& flutter create --platforms=windows --project-name=ni_hao_robot --no-pub $scaffold
if ($LASTEXITCODE -ne 0) { throw 'Flutter scaffold generation failed; application files were not changed.' }

Copy-Item -LiteralPath (Join-Path $scaffold 'windows') -Destination $runner -Recurse
Copy-Item -LiteralPath (Join-Path $scaffold '.metadata') -Destination $metadata
Write-Output "Generated Windows runner. Temporary SDK scaffold retained at: $scaffold"
Write-Output 'Next: flutter pub get, dart format ., flutter analyze, flutter test, flutter run -d windows'
