#!/usr/bin/env bash

set -e  # Exit on error

# Step 1: Set install directory
INSTALL_DIR="$HOME/bin"
mkdir -p "$INSTALL_DIR"

# Step 2: Download latest Syncthing release for Windows 64-bit
echo "[*] Fetching latest Syncthing release..."

LATEST_URL=$(curl -s https://api.github.com/repos/syncthing/syncthing/releases/latest \
    | grep "browser_download_url" \
    | grep "windows-amd64.zip" \
    | cut -d '"' -f 4)

if [ -z "$LATEST_URL" ]; then
    echo "[!] Failed to get download URL"
    exit 1
fi

ZIP_FILE="/tmp/syncthing.zip"

echo "[*] Downloading: $LATEST_URL"
curl -L "$LATEST_URL" -o "$ZIP_FILE"

# Step 3: Extract
echo "[*] Extracting syncthing.exe..."
unzip -j "$ZIP_FILE" "*/syncthing.exe" -d "$INSTALL_DIR"

# Step 4: Clean up
rm "$ZIP_FILE"

# Step 5: Add to PATH (if needed)
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo "[*] Adding $INSTALL_DIR to PATH in ~/.bashrc"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> ~/.bashrc
    echo "[*] Please run 'source ~/.bashrc' or restart your terminal."
fi

# Step 6: Done
echo "[✔] Syncthing installed successfully in $INSTALL_DIR"
echo "[i] You can run it with: syncthing.exe"
