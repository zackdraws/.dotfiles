#!/bin/bash

USERNAME=$(cmd.exe /c "echo %USERNAME%" | tr -d '\r')
OUTFILE="/mnt/c/Users/zacha/Desktop/screen_record_$(date +%Y-%m-%d_%H-%M-%S).mp4"

ffmpeg.exe -y -f gdigrab -framerate 24 -offset_x 0 -offset_y 0 -video_size 1920x1080 -i desktop -t 300 "$OUTFILE"

echo "Recording saved to: $OUTFILE"
explorer.exe "$(wslpath -w "$(dirname "$OUTFILE")")"
