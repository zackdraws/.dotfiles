#!/bin/bash

# Script to merge an MP3 and an MP4 file into a single file.
# Requires ffmpeg to be installed.

# Usage: ./merge_audio_video.sh <output_file> <mp3_file> <mp4_file>

# Check if all required arguments are provided
if [ $# -ne 3 ]
then
    echo "Usage: $0 <output_file> <mp3_file> <mp4_file>"
    exit 1
fi

output_file="$1"
mp3_file="$2"
mp4_file="$3"

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    echo "ffmpeg is not installed. Please install it."
    echo "  On Debian/Ubuntu: sudo apt-get install ffmpeg"
    echo "  On Fedora/CentOS/RHEL: sudo yum install ffmpeg"
    exit 1
fi

# Check if input files exist
if [ ! -f "$mp3_file" ]
then
    echo "Error: MP3 file '$mp3_file' not found."
    exit 1
fi

if [ ! -f "$mp4_file" ]
then
    echo "Error: MP4 file '$mp4_file' not found."
    exit 1
fi

# Construct the ffmpeg command
ffmpeg -i "$mp3_file" -i "$mp4_file" -c:a aac -c:v copy "$output_file"

# Check the return code of ffmpeg
if [ $? -eq 0 ]
then
    echo "Successfully merged '$mp3_file' and '$mp4_file' into '$output_file'"
else
    echo "Error: Failed to merge audio and video using ffmpeg"
    exit 1
fi

exit 0
`
