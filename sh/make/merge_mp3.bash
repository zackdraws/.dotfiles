#!/bin/bash
echo "./merge_audio_video.sh <output_file> <mp3_file> <mp4_file>"
if [ $# -ne 3 ]
then
    echo "Usage: $0 <output_file> <mp3_file> <mp4_file>"
    exit 1
fi
output_file="$1"
mp3_file="$2"
mp4_file="$3"
if ! command -v ffmpeg &> /dev/null
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
ffmpeg -i "$mp3_file" -i "$mp4_file" -c:a aac -c:v copy "$output_file"
if [ $? -eq 0 ]
then
    echo "'$mp3_file' and '$mp4_file' is now '$output_file'"
else
    echo "Error: Failed to merge audio and video using ffmpeg"
    exit 1
fi
exit 0
