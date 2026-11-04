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
$sdkBin = Split-Path -Parent $flutterExecutable
$dartRuntime = Join-Path $sdkBin 'cache\dart-sdk\bin\dart.exe'
$dartStamp = Join-Path $sdkBin 'cache\engine-dart-sdk.stamp'
if ((Test-Path -LiteralPath $dartStamp) -and -not (Test-Path -LiteralPath $dartRuntime)) {
    throw "Flutter's cached Dart runtime is missing: $dartRuntime. The SDK cache marker is stale. Follow the missing-runtime recovery in docs/SETUP.md, or set NIHAO_FLUTTER_ROOT to a complete SDK."
}
$env:FLUTTER_SUPPRESS_ANALYTICS = 'true'
& $flutterExecutable @args
exit $LASTEXITCODE
