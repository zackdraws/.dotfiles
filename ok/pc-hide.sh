#!/usr/bin/env bash
# Base paths
USER_DIR="/c/users/ok"
DOCS="$USER_DIR/Documents"
DOTFILES="$DOCS/.dotfiles-p"
mkdir -p "$DOTFILES"
echo " Zoxide bootstrap "
zoxide add "$DOCS"
echo " Hide clutter in Documents "
# Games / misc folders
for dir in \
  "Horizon Zero Dawn" \
  "Indivisible" \
  "Max 8" \
  "OVERWATCH" \
  "SKIDROW" \
  "Ratchet & Clank - Rift Apart" \
  "Rockstar Games" \
  "Skunkape Games" \
  "my games"
do
  attrib +h "$DOCS/$dir"
done
for dir in \
  "Adobe" \
  "Autodesk Application Manager" \
  "Bluetooth Folder" \
  "CPY_SAVES" \
  "Custom Office Templates" \
  "Downloaded Installations" \
  "Outlook Files" \
  "Transcribed Files" \
  "Zoom" \
  "xgen"
do
  attrib +h "$DOCS/$dir"
done
for dir in \
  "maya" \
  "PowerToys" \
  "Powershell" \
  "WindowsPowerShell" \
  "scriptable"
do
  attrib +h "$DOCS/$dir"
done
for dir in \
  "Toon Boom Animation" \
  "Toon Boom Storyboard Pro Library" \
  "Toon Boom Harmony Premium Library"
do
  attrib +h "$DOCS/$dir"
done
echo " Symlink dotfile-managed folders "
ln -sf "$DOCS/Adobe" "$DOTFILES/"
ln -sf "$DOCS/maya" "$DOTFILES/"
ln -sf "$DOCS/PowerToys" "$DOTFILES/"
ln -sf "$DOCS/Powershell" "$DOTFILES/"
ln -sf "$DOCS/WindowsPowerShell" "$DOTFILES/"
ln -sf "$DOCS/Toon Boom Animation" "$DOTFILES/"
ln -sf "$DOCS/Toon Boom Storyboard Pro Library" "$DOTFILES/"
ln -sf "$DOCS/Toon Boom Harmony Premium Library" "$DOTFILES/"
# Root-level links
ln -sf "/c/Autodesk" "$DOTFILES/"
ln -sf "/c/flexlm" "$DOTFILES/"
ln -sf "/c/inetpub" "$DOTFILES/"
echo " Hide root-level items "
for dir in \
  "/c/Autodesk" \
  "/c/flexlm" \
  "/c/inetpub"
do
  attrib +h "$dir"
done

echo " Hide user home dot folders "

for dir in \
  ".bun" \
  ".cargo" \
  ".insomniac" \
  ".rustup" \
  ".thumbnails" \
  ".ansel"
do
  attrib +h "$USER_DIR/$dir"
done

echo " Hide default Windows folders "

for dir in \
  "3D Objects" \
  "Contacts" \
  "Favorites" \
  "Saved Games" \
  "Searches"
do
  attrib +h "$USER_DIR/$dir"
done

echo " Hide system directories "

for dir in \
  "/c/PerfLogs" \
  "/c/Windows" \
  "/c/Windows.old"
do
  attrib +h "$dir"
done

echo "Done."
