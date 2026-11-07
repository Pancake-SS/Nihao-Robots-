# Run as administrator. Installs only Mandarin speech, without changing display language.
$ErrorActionPreference = 'Stop'
$resultPath = Join-Path (Split-Path -Parent $PSScriptRoot) '.dart_tool\mandarin-voice-install.json'
$logPath = Join-Path (Split-Path -Parent $PSScriptRoot) '.dart_tool\mandarin-voice-dism.log'
$capability = 'Language.TextToSpeech~~~zh-CN~0.0.1.0'
try {
    @{ state = 'Installing'; capability = $capability } |
        ConvertTo-Json | Set-Content -LiteralPath $resultPath -Encoding UTF8
    $state = Get-WindowsCapability -Online -Name $capability -LogPath $logPath
    $restart = $false
    if ($state.State -ne 'Installed') {
        $installed = Add-WindowsCapability -Online -Name $capability -LogPath $logPath
        $restart = $installed.RestartNeeded
    }
    $state = Get-WindowsCapability -Online -Name $capability -LogPath $logPath
    @{ state = $state.State.ToString(); restartNeeded = $restart } |
        ConvertTo-Json | Set-Content -LiteralPath $resultPath -Encoding UTF8
} catch {
    @{ state = 'Failed'; error = $_.Exception.Message } |
        ConvertTo-Json | Set-Content -LiteralPath $resultPath -Encoding UTF8
    exit 1
}
