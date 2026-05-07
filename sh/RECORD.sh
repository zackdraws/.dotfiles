sleep 5; ffmpeg -f gdigrab -framerate 30 -i desktop -c:v libx264 -preset veryfast -pix_fmt yuv420p /c/Users/ok/Videos/recording-screen.mp4
