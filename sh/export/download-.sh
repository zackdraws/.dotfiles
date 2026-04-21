#!/bin/bash
if [ -z "$1" ]; then
echo "Usage: $0 <URL>"
exit 1
fi
URL=$1
mkdir -p images
echo "Downloading images from $URL..."
curl -s "$URL" | grep -oP 'http[^"]+\.(jpg|jpeg|png|gif|bmp)' | sed 's|^/|http://|' | xargs -n 1 curl -O -P ./images
echo "Done"
