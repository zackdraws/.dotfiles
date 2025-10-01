param (
    [Parameter(Mandatory=$true)]
    [string]$Path,
    [switch]$WhatIf
)

# Add System.Drawing assembly for image handling
Add-Type -AssemblyName System.Drawing

# Initialize counters
$script:totalFiles = 0
$script:successCount = 0
$script:errorCount = 0

# Get all PNG files recursively
Write-Host "Scanning for PNG files in $Path..." -ForegroundColor Cyan
$pngFiles = Get-ChildItem -Path $Path -Filter "*.png" -Recurse
$totalCount = $pngFiles.Count

if ($totalCount -eq 0) {
    Write-Host "No PNG files found in the specified directory." -ForegroundColor Yellow
    exit
}

Write-Host "Found $totalCount PNG files to process." -ForegroundColor Cyan

# Process each file
$currentFile = 0
foreach ($file in $pngFiles) {
    $currentFile++
    $jpgPath = $file.FullName -replace '\.png$', '.jpg'
    
    # Show progress
    Write-Progress -Activity "Converting PNG files to JPG" `
        -Status "Processing $($file.Name)" `
        -PercentComplete (($currentFile / $totalCount) * 100) `
        -CurrentOperation "File $currentFile of $totalCount"
    
    try {
        if (-not $WhatIf) {
            $image = [System.Drawing.Image]::FromFile($file.FullName)
            $image.Save($jpgPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
            $image.Dispose()
            Write-Host "[$currentFile/$totalCount] Converted: $($file.Name) -> $(Split-Path $jpgPath -Leaf)" -ForegroundColor Green
            $script:successCount++
        } else {
            Write-Host "[$currentFile/$totalCount] WhatIf: Would convert $($file.Name) to $(Split-Path $jpgPath -Leaf)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "[$currentFile/$totalCount] Error converting $($file.Name): $_" -ForegroundColor Red
        $script:errorCount++
    }
    $script:totalFiles++
}

Write-Progress -Activity "Converting PNG files to JPG" -Completed

# Display summary
Write-Host "`nConversion Summary:" -ForegroundColor Cyan
Write-Host "Total files processed: $totalFiles" -ForegroundColor White
Write-Host "Successful conversions: $successCount" -ForegroundColor Green
if ($errorCount -gt 0) {
    Write-Host "Failed conversions: $errorCount" -ForegroundColor Red
}

if (-not $WhatIf) {
    Write-Host "`nAll JPG files have been created while preserving the original PNG files." -ForegroundColor Cyan
} else {
    Write-Host "`nThis was a simulation. No files were actually converted." -ForegroundColor Yellow
}

