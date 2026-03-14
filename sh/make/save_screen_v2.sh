#!/bin/bash

# Get your WSL home directory
WSL_HOME="$HOME"

# Define filename with timestamp
FILENAME="screen_record_$(date +%Y-%m-%d_%H-%M-%S).mp4"

# Full WSL path to save recording
WSL_PATH="$WSL_HOME/$FILENAME"

# Convert to Windows path
WIN_PATH=$(wslpath -w "$WSL_PATH")

# Use ffmpeg from Windows (installed via choco)
FFMPEG="ffmpeg.exe"

# Record full desktop with 30 FPS
"$FFMPEG" -y -f gdigrab -framerate 30 -i desktop "$WIN_PATH"

# Confirm result
if [ $? -eq 0 ]; then
  echo "✅ Recording saved to: $WSL_PATH"
else
  echo "❌ Recording failed."
fi
