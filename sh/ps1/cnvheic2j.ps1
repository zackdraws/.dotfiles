# Ensure exiftool and heif-convert are in your PATH

$heicFiles = Get-ChildItem -Path . -Filter *.HEIC

foreach ($file in $heicFiles) {
    Write-Host "Processing $($file.Name)..."

    # Create temp filename for stripped metadata
    $tmpFile = "$($file.BaseName)_stripped.HEIC"

    # Strip metadata using exiftool (-all= removes all metadata, -o writes output to new file)
    & exiftool -all= -o $tmpFile $file.FullName | Out-Null

    if (Test-Path $tmpFile) {
        # Convert stripped HEIC to JPG
        $jpgFile = "$($file.BaseName).jpg"
        & heif-convert $tmpFile $jpgFile

        # Remove temp stripped file
        Remove-Item $tmpFile

        Write-Host "Converted $($file.Name) to $jpgFile without metadata"
    }
    else {
        Write-Host "Failed to strip metadata for $($file.Name)"
    }
}
