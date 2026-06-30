#!/usr/bin/env bash
set -euo pipefail

dotfiles_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
mail_root="${MAIL_ROOT:-$HOME/Mail}"
categories="Inbox Action Projects Finance Receipts Art Family Newsletters Archive Sent Drafts Trash"

backup_path() {
  local target="$1"
  local stamp
  stamp="$(date +%Y%m%d-%H%M%S)"
  echo "$target.backup-$stamp"
}

install_link() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo "Already linked: $target"
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    local backup
    backup="$(backup_path "$target")"
    mv "$target" "$backup"
    echo "Backed up existing file: $backup"
  fi

  if ln -s "$source" "$target" 2>/dev/null; then
    echo "Linked: $target -> $source"
  else
    cp "$source" "$target"
    echo "Copied: $source -> $target"
  fi
}

for category in $categories; do
  mkdir -p "$mail_root/$category/cur" "$mail_root/$category/new" "$mail_root/$category/tmp"
done

install_link "$dotfiles_root/.config/mutt/muttrc" "$HOME/.config/mutt/muttrc"
install_link "$dotfiles_root/.config/mutt/categories.muttrc" "$HOME/.config/mutt/categories.muttrc"
install_link "$dotfiles_root/.config/mutt/muttrc" "$HOME/.mutt/muttrc"
install_link "$dotfiles_root/.config/whkdrc" "$HOME/.config/whkdrc"

mkdir -p "$HOME/Videos" "$HOME/.local/bin"
chmod +x "$dotfiles_root/sh/run/ffmpeg-record" "$dotfiles_root/sh/run/record.sh"
install_link "$dotfiles_root/sh/run/ffmpeg-record" "$HOME/.local/bin/ffmpeg-record"
install_link "$dotfiles_root/sh/run/record.sh" "$HOME/.local/bin/record.sh"

echo
echo "Done."
echo "Mutt categories were created under: $mail_root"
echo "Screen recordings save to the current user's Videos folder."
echo "Windows Super+Alt+J is configured in: $dotfiles_root/.config/whkdrc"
