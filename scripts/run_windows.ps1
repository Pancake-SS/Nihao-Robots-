$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$portableRoot = Join-Path $projectRoot 'build\windows\portable'
$marker = Join-Path $portableRoot 'latest.txt'
if (-not (Test-Path -LiteralPath $marker)) {
    throw 'No portable Windows app found. Run scripts\build_windows.ps1 first.'
}
$directory = [System.IO.Path]::GetFullPath((Get-Content -LiteralPath $marker -Raw).Trim())
$allowedPrefix = [System.IO.Path]::GetFullPath($portableRoot) + [System.IO.Path]::DirectorySeparatorChar
if (-not $directory.StartsWith($allowedPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw 'The portable app path is outside the project build folder.'
}
foreach ($required in @('ni_hao_robot.exe', 'flutter_windows.dll', 'data\flutter_assets')) {
    if (-not (Test-Path -LiteralPath (Join-Path $directory $required))) {
        throw "The portable app is missing $required. Run scripts\build_windows.ps1 again."
    }
}
Start-Process -FilePath (Join-Path $directory 'ni_hao_robot.exe') -WorkingDirectory $directory
