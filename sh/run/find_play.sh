find . -type f \( -name "*.mp4" -o -name "*.mkv" \) -print0 | xargs -0 mpv
