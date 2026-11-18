param(
    [Parameter(Mandatory = $true)]
    [string]$SourceDirectory
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$source = [System.IO.Path]::GetFullPath($SourceDirectory)
foreach ($required in @('ni_hao_robot.exe', 'flutter_windows.dll', 'data\flutter_assets')) {
    if (-not (Test-Path -LiteralPath (Join-Path $source $required))) {
        throw "Incomplete Windows build: $required is missing from $source"
    }
}

$portableRoot = Join-Path $projectRoot 'build\windows\portable'
$packageDirectory = Join-Path $portableRoot ([guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $packageDirectory -Force | Out-Null
Get-ChildItem -LiteralPath $source | Where-Object { $_.Extension -ne '.pdb' } | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $packageDirectory -Recurse -Force
}
foreach ($required in @('ni_hao_robot.exe', 'flutter_windows.dll', 'data\flutter_assets')) {
    if (-not (Test-Path -LiteralPath (Join-Path $packageDirectory $required))) {
        throw "Incomplete portable package: $required is missing from $packageDirectory"
    }
}
Set-Content -LiteralPath (Join-Path $portableRoot 'latest.txt') -Value $packageDirectory -Encoding UTF8
Write-Output "Portable Windows app: $packageDirectory"
Write-Output "Launch with: powershell -NoProfile -ExecutionPolicy Bypass -File scripts\run_windows.ps1"
