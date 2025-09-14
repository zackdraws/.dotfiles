#!/bin/bash

# Directory containing your music files
directory="/path/to/your/music/folder"

for file in "$directory"/*.mp3; do
    # Extract tags using ffprobe or another tool (e.g., eyeD3 or mutagen in Python)
    artist=$(id3v2 -l "$file" | grep "TPE1" | cut -d ':' -f2)
    title=$(id3v2 -l "$file" | grep "TIT2" | cut -d ':' -f2)
    
    # If artist or title is missing, skip this file
    if [[ -z "$artist" || -z "$title" ]]; then
        echo "Skipping $file, missing tags"
        continue
    fi
    
    # Rename file based on tags
    new_name="${artist} - ${title}.mp3"
    mv "$file" "$directory/$new_name"
    
    echo "Renamed $file to $new_name"
done
