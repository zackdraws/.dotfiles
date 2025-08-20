#!/bin/bash



# Check if the correct number of arguments is passed

if [ "$#" -ne 3 ]; then

  echo "Usage: $0 <input_video> <output_video> <target_size_mb>"

  echo "Example: $0 input_video.mp4 output_video.mp4 20"

  exit 1

fi



# Input parameters

input_video="$1"

output_video="$2"

target_size_mb="$3"



# Calculate the target size in kilobits (1 MB = 8000 kilobits)

target_size_kb=$((target_size_mb * 8000))



# Get the duration of the video in seconds

duration=$(ffmpeg -i "$input_video" 2>&1 | grep "Duration" | awk '{print $2}' | tr -d ,)

IFS=: read -r hours minutes seconds <<< "$duration"

duration_seconds=$((hours * 3600 + minutes * 60 + ${seconds%.*}))



# Calculate the target bitrate in kilobits per second

target_bitrate_kbps=$((target_size_kb / duration_seconds))



# Print some useful info

echo "Target Size: $target_size_mb MB"

echo "Video Duration: $duration_seconds seconds"

echo "Target Bitrate: $target_bitrate_kbps kbps"



# Run FFmpeg to compress and resize the video

ffmpeg -i "$input_video" -c:v libx264 -b:v ${target_bitrate_kbps}k -c:a aac -b:a 128k -preset fast "$output_video"



echo "Video compression complete: $output_video"
