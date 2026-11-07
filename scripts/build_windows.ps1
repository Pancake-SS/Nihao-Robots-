param(
    [ValidateSet('debug', 'release')]
    [string]$Configuration = 'debug'
)

# Flutter's Windows build rejects the exclamation mark in this workspace path.
# Stage only application sources into a new safe path; never move/delete the repo.
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$stageRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('nihao-windows-' + [guid]::NewGuid().ToString('N'))
$wrapper = Join-Path $PSScriptRoot 'flutter.ps1'
$nugetExecutable = & (Join-Path $PSScriptRoot 'ensure_nuget.ps1')
$env:PATH = (Split-Path -Parent $nugetExecutable) + ';' + $env:PATH
New-Item -ItemType Directory -Path $stageRoot | Out-Null
foreach ($entry in @('lib', 'assets', 'windows', 'pubspec.yaml', 'pubspec.lock', '.metadata')) {
    Copy-Item -LiteralPath (Join-Path $projectRoot $entry) -Destination $stageRoot -Recurse
}
Write-Output "Windows build source snapshot: $stageRoot"
Push-Location -LiteralPath $stageRoot
try {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $wrapper pub get
    if ($LASTEXITCODE -ne 0) { throw "Package/plugin setup failed. Snapshot retained at $stageRoot" }
    & powershell -NoProfile -ExecutionPolicy Bypass -File $wrapper build windows "--$Configuration" --no-pub
    if ($LASTEXITCODE -ne 0) { throw "Windows build failed. Snapshot retained at $stageRoot" }
    Write-Output (Join-Path $stageRoot "build\windows\x64\runner\$Configuration\ni_hao_robot.exe")
} finally {
    Pop-Location
}
