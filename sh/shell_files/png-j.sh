# Save this as convert_png_to_jpg.ps1

# Add System.Drawing assembly for image handling
Add-Type -AssemblyName System.Drawing

# Get all PNG files in the current directory
$pngFiles = Get-ChildItem -Filter "*.png"

foreach ($file in $pngFiles) {
    try {
        $jpgPath = [System.IO.Path]::ChangeExtension($file.FullName, "jpg")
        $image = [System.Drawing.Image]::FromFile($file.FullName)
        $image.Save($jpgPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
        $image.Dispose()
        Write-Host "Converted: $($file.Name) -> $([System.IO.Path]::GetFileName($jpgPath))" -ForegroundColor Green
    }
    catch {
        Write-Host "Error converting $($file.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`nConversion complete!" -ForegroundColor Cyan
