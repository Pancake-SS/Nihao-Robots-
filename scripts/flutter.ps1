# Use a supplied SDK, an SDK on PATH, or this task's portable installation.
# This wrapper never changes the machine/user PATH.
$ErrorActionPreference = 'Stop'
$portableRoot = Join-Path ([System.IO.Path]::GetTempPath()) 'nihao-tools'
if ($env:NIHAO_FLUTTER_ROOT) {
    $flutterExecutable = Join-Path $env:NIHAO_FLUTTER_ROOT 'bin\flutter.bat'
} elseif (Get-Command flutter -ErrorAction SilentlyContinue) {
    $flutterExecutable = (Get-Command flutter).Source
} else {
    $flutterExecutable = Join-Path $portableRoot 'flutter\bin\flutter.bat'
    if (-not $env:PUB_CACHE) {
        $env:PUB_CACHE = Join-Path $portableRoot 'pub-cache'
    }
}
if (-not (Test-Path -LiteralPath $flutterExecutable)) {
    throw 'Flutter SDK not found. Set NIHAO_FLUTTER_ROOT or follow docs/SETUP.md.'
}
$env:FLUTTER_SUPPRESS_ANALYTICS = 'true'
& $flutterExecutable @args
exit $LASTEXITCODE
