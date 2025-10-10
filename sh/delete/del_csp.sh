#!/bin/bash
echo "🧹 Cleaning up Clip Studio user data and settings..."
# -------- DELETE APPDATA --------
rm -rf "/mnt/c/Users/Zacha/AppData/Roaming/CELSYS"
rm -rf "/mnt/c/Users/Zacha/AppData/Local/CELSYS"
# -------- DELETE DOCUMENTS --------
rm -rf "/mnt/c/Users/Zacha/Documents/CELSYS"
# -------- DELETE PROGRAMDATA (may fail without admin) --------
sudo rm -rf "/mnt/c/Users/Zacha/ProgramData/CELSYS"
# -------- DELETE PROGRAM FILES (if installed manually) --------
sudo rm -rf "/c/Program Files/CELSYS"
sudo rm -rf "/c/Program Files (x86)/CELSYS"



