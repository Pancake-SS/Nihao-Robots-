# Resize the shared app logo into Android's launcher icon densities.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$projectRoot = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $projectRoot 'assets\branding\nihao_robot_head.png'
$resRoot = Join-Path $projectRoot 'android\app\src\main\res'
$source = [System.Drawing.Bitmap]::FromFile($sourcePath)
try {
    $densities = [ordered]@{
        mdpi = 48
        hdpi = 72
        xhdpi = 96
        xxhdpi = 144
        xxxhdpi = 192
    }
    foreach ($entry in $densities.GetEnumerator()) {
        $size = [int]$entry.Value
        $targetDirectory = Join-Path $resRoot "mipmap-$($entry.Key)"
        New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null
        $targetPath = Join-Path $targetDirectory 'ic_launcher.png'
        $bitmap = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        try {
            $graphics.Clear([System.Drawing.Color]::Transparent)
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
            $scale = [Math]::Min($size / $source.Width, $size / $source.Height)
            $width = [int][Math]::Round($source.Width * $scale)
            $height = [int][Math]::Round($source.Height * $scale)
            $left = [int][Math]::Floor(($size - $width) / 2)
            $top = [int][Math]::Floor(($size - $height) / 2)
            $graphics.DrawImage($source, [System.Drawing.Rectangle]::new($left, $top, $width, $height))
            $bitmap.Save($targetPath, [System.Drawing.Imaging.ImageFormat]::Png)
        } finally {
            $graphics.Dispose()
            $bitmap.Dispose()
        }
    }
} finally {
    $source.Dispose()
}
