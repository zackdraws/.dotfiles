$ErrorActionPreference = "Stop"

$scriptName = "save_psd_jpeg_web_yyyymmddhhmm.jsx"
$source = Join-Path $PSScriptRoot $scriptName
$photoshopScripts = "C:\Program Files\Adobe\Adobe Photoshop 2025\Presets\Scripts"
$target = Join-Path $photoshopScripts $scriptName

if (-not (Test-Path -LiteralPath $source)) {
    throw "Source script not found: $source"
}

if (-not (Test-Path -LiteralPath $photoshopScripts)) {
    New-Item -ItemType Directory -Path $photoshopScripts -Force | Out-Null
}

Copy-Item -LiteralPath $source -Destination $target -Force

Write-Host "Installed Photoshop script:"
Write-Host "  $target"
Write-Host ""
Write-Host "Restart Photoshop 2025, then run it from File > Scripts > save_psd_jpeg_web_yyyymmddhhmm."
