#!/bin/bash

# Check if the user provided a URL
if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

# The URL passed as an argument
URL=$1

# Create a directory for images (if it doesn't already exist)
mkdir -p images

# Use curl to download the webpage, then extract image URLs and download them
echo "Downloading images from $URL..."

curl -s "$URL" | grep -oP 'http[^"]+\.(jpg|jpeg|png|gif|bmp)' | sed 's|^/|http://|' | xargs -n 1 curl -O -P ./images

echo "Download complete. All images are saved in the 'images' folder."

