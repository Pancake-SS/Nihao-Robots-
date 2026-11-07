# Build-only tool, pinned to the official supported release. No global PATH edits.
$ErrorActionPreference = 'Stop'
$toolDirectory = Join-Path $env:LOCALAPPDATA 'NihaoRobotTools\nuget\7.9.0'
$toolPath = Join-Path $toolDirectory 'nuget.exe'
$expectedHash = '992D70CAC5B06C38EFEC91806CABA64CDCC07E6D963A0959DBBBAF264D33B800'
New-Item -ItemType Directory -Path $toolDirectory -Force | Out-Null
if (-not (Test-Path -LiteralPath $toolPath)) {
    $downloadPath = Join-Path $toolDirectory ('nuget-' + [guid]::NewGuid().ToString('N') + '.exe')
    Invoke-WebRequest -UseBasicParsing -Uri 'https://dist.nuget.org/win-x86-commandline/v7.9.0/nuget.exe' -OutFile $downloadPath
    $signature = Get-AuthenticodeSignature -LiteralPath $downloadPath
    if ($signature.Status -ne 'Valid' -or $signature.SignerCertificate.Subject -notmatch 'O=Microsoft Corporation') {
        throw "NuGet signature verification failed; download retained at $downloadPath"
    }
    if ((Get-FileHash -LiteralPath $downloadPath -Algorithm SHA256).Hash -ne $expectedHash) {
        throw "NuGet checksum mismatch; download retained at $downloadPath"
    }
    Move-Item -LiteralPath $downloadPath -Destination $toolPath
}
$signature = Get-AuthenticodeSignature -LiteralPath $toolPath
if ($signature.Status -ne 'Valid' -or $signature.SignerCertificate.Subject -notmatch 'O=Microsoft Corporation') {
    throw "NuGet signature verification failed at $toolPath"
}
if ((Get-FileHash -LiteralPath $toolPath -Algorithm SHA256).Hash -ne $expectedHash) {
    throw "NuGet checksum mismatch at $toolPath"
}
Write-Output $toolPath
