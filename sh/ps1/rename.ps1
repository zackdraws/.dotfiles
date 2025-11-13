# Loop through all files in the current directory
Get-ChildItem -File | ForEach-Object {
    $file = $_
    
    # Get the last modified timestamp of the file
    $modifiedDate = $file.LastWriteTime

    # Format the timestamp as YYYYMMDDHHMM
    $formattedDate = $modifiedDate.ToString("yyyyMMddHHmm")

    # Extract the file extension
    $extension = $file.Extension.TrimStart('.')

    # If the file doesn't have an extension, use "unknown"
    if ([string]::IsNullOrEmpty($extension)) {
        $extension = "unknown"
    }

    # Construct the base new filename with the 'iph_' prefix and the formatted date and time
    $newFilename = "iph_$formattedDate.$extension"
    
    # Initialize the counter
    $counter = 0
    
    # Check if the new filename already exists, and add a sequence number if it does
    while (Test-Path $newFilename) {
        $counter++
        $formattedCounter = $counter.ToString("D2")  # Ensure the counter is formatted as two digits
        $newFilename = "iph_${formattedDate}_${formattedCounter}.$extension"
    }
    
    # Rename the file
    Rename-Item -Path $file.FullName -NewName $newFilename

    # Output the renaming operation
    Write-Host "Renamed '$($file.Name)' to '$newFilename'"
}
