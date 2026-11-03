param(
    [string]$PreviewDirectory = (Join-Path ([System.IO.Path]::GetTempPath()) 'nihao-robot-asset-audit')
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public static class RobotPixelAudit {
    public static long[] CountAlpha(Bitmap source) {
        using (var bitmap = new Bitmap(source.Width, source.Height, PixelFormat.Format32bppArgb)) {
            using (var graphics = Graphics.FromImage(bitmap)) {
                graphics.CompositingMode = System.Drawing.Drawing2D.CompositingMode.SourceCopy;
                graphics.DrawImageUnscaled(source, 0, 0);
            }
            var data = bitmap.LockBits(new Rectangle(0, 0, bitmap.Width, bitmap.Height), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
            try {
                var bytes = new byte[Math.Abs(data.Stride) * data.Height];
                Marshal.Copy(data.Scan0, bytes, 0, bytes.Length);
                long clear = 0, partial = 0, opaque = 0;
                for (var y = 0; y < data.Height; y++) {
                    for (var x = 0; x < data.Width; x++) {
                        var alpha = bytes[y * Math.Abs(data.Stride) + x * 4 + 3];
                        if (alpha == 0) clear++;
                        else if (alpha == 255) opaque++;
                        else partial++;
                    }
                }
                return new long[] {clear, partial, opaque};
            } finally { bitmap.UnlockBits(data); }
        }
    }
}
'@

$projectRoot = Split-Path -Parent $PSScriptRoot
$assetRoot = Join-Path $projectRoot 'Robot images'
$files = @(Get-ChildItem -LiteralPath $assetRoot -Filter '*.png' -File | Sort-Object Name)
New-Item -ItemType Directory -Path $PreviewDirectory -Force | Out-Null
$inventory = @()
$font = New-Object System.Drawing.Font('Segoe UI', 12)
$textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(29, 38, 52))
$lightBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(250, 246, 236))
$darkBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(35, 44, 59))

try {
    for ($batch = 0; $batch -lt [Math]::Ceiling($files.Count / 10.0); $batch++) {
        $sheet = New-Object System.Drawing.Bitmap(1800, 1080)
        $graphics = [System.Drawing.Graphics]::FromImage($sheet)
        $graphics.Clear([System.Drawing.Color]::White)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        try {
            for ($slot = 0; $slot -lt 10; $slot++) {
                $index = $batch * 10 + $slot
                if ($index -ge $files.Count) { break }
                $file = $files[$index]
                $bitmap = New-Object System.Drawing.Bitmap($file.FullName)
                try {
                    $counts = [RobotPixelAudit]::CountAlpha($bitmap)
                    $id = 'asset-{0:D2}' -f ($index + 1)
                    $inventory += [ordered]@{
                        id = $id
                        path = 'Robot images/' + $file.Name
                        width = $bitmap.Width
                        height = $bitmap.Height
                        bytes = $file.Length
                        sha256 = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
                        transparentPixels = $counts[0]
                        partialAlphaPixels = $counts[1]
                        opaquePixels = $counts[2]
                    }
                    $left = ($slot % 5) * 360
                    $top = [Math]::Floor($slot / 5) * 540
                    $graphics.FillRectangle($lightBrush, $left, $top + 40, 180, 480)
                    $graphics.FillRectangle($darkBrush, $left + 180, $top + 40, 180, 480)
                    $graphics.DrawString($id + ' / ' + ($file.Name -replace '^.*PM-', '#'), $font, $textBrush, $left + 8, $top + 10)
                    $scale = [Math]::Min(170.0 / $bitmap.Width, 460.0 / $bitmap.Height)
                    $width = [int]($bitmap.Width * $scale)
                    $height = [int]($bitmap.Height * $scale)
                    $y = [int]($top + 50 + (460 - $height) / 2)
                    $graphics.DrawImage($bitmap, [int]($left + (180 - $width) / 2), $y, $width, $height)
                    $graphics.DrawImage($bitmap, [int]($left + 180 + (180 - $width) / 2), $y, $width, $height)
                } finally { $bitmap.Dispose() }
            }
            $previewPath = Join-Path $PreviewDirectory ('robots-{0}.png' -f ($batch + 1))
            $sheet.Save($previewPath, [System.Drawing.Imaging.ImageFormat]::Png)
            Write-Output $previewPath
        } finally { $graphics.Dispose(); $sheet.Dispose() }
    }
    $inventoryPath = Join-Path $projectRoot 'docs/asset_inventory.json'
    $inventory | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $inventoryPath -Encoding UTF8
    Write-Output $inventoryPath
} finally {
    $font.Dispose()
    $textBrush.Dispose()
    $lightBrush.Dispose()
    $darkBrush.Dispose()
}
