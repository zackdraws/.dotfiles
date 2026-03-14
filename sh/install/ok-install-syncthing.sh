#!/bin/bash
REPO_DIR="$HOME/syncthing"
# Check if repo exists, clone if not
if [ ! -d "$REPO_DIR" ]; then
  echo "Syncthing repo not found. Cloning..."
  git clone https://github.com/syncthing/syncthing.git "$REPO_DIR" || { echo "Git clone failed"; exit 1; }
else
  echo "Updating Syncthing repo..."
  cd "$REPO_DIR" || exit
  git pull || { echo "Git pull failed"; exit 1; }
fi
# Build Syncthing
echo "Building Syncthing..."
cd "$REPO_DIR" || exit
go build || { echo "Build failed"; exit 1; }
# Run Syncthing
echo "Running Syncthing..."
./syncthing.exe
