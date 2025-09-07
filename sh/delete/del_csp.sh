#!/bin/bash

# -------- CONFIG --------
# URL of the Clip Studio Paint EX installer (you can update this if needed)
INSTALLER_URL="https://vd.clip-studio.com/installer/csp_wn_installer.exe"
INSTALLER_NAME="csp_installer.exe"
INSTALLER_PATH="$HOME/Downloads/$INSTALLER_NAME"

echo "🧹 Cleaning up Clip Studio user data and settings..."

# -------- DELETE APPDATA --------
rm -rf "/c/Users/$USERNAME/AppData/Roaming/CELSYS"
rm -rf "/c/Users/$USERNAME/AppData/Local/CELSYS"

# -------- DELETE DOCUMENTS --------
rm -rf "/c/Users/$USERNAME/Documents/CELSYS"

# -------- DELETE PROGRAMDATA (may fail without admin) --------
sudo rm -rf "/c/ProgramData/CELSYS"

# -------- DELETE PROGRAM FILES (if installed manually) --------
sudo rm -rf "/c/Program Files/CELSYS"
sudo rm -rf "/c/Program Files (x86)/CELSYS"

echo "✅ User data and application folders removed."

# -------- DOWNLOAD INSTALLER --------
echo "⬇️ Downloading Clip Studio Paint installer..."
curl -L "$INSTALLER_URL" -o "$INSTALLER_PATH"

if [[ -f "$INSTALLER_PATH" ]]; then
  echo "✅ Installer downloaded to: $INSTALLER_PATH"
  
  # -------- OPTIONAL: Run installer --------
  echo "🚀 Launching installer..."
  cmd.exe /C start "" "$(cygpath -w "$INSTALLER_PATH")"
else
  echo "❌ Download failed. Check URL or internet connection."
fi
