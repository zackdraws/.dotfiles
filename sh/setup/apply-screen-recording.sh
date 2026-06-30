#!/usr/bin/env bash
set -euo pipefail

dotfiles_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"

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

windows_home=""
if [ -n "${USERPROFILE:-}" ] && command -v cygpath >/dev/null 2>&1; then
  windows_home="$(cygpath -u "$USERPROFILE")"
fi

home_targets=("$HOME")
if [ -n "$windows_home" ] && [ "$windows_home" != "$HOME" ]; then
  home_targets+=("$windows_home")
fi

chmod +x "$dotfiles_root/sh/run/ffmpeg-record" "$dotfiles_root/sh/run/record.sh"

for home_target in "${home_targets[@]}"; do
  mkdir -p "$home_target/Videos"
  install_link "$dotfiles_root/.config/whkdrc" "$home_target/.config/whkdrc"
done

mkdir -p "$HOME/.local/bin"
install_link "$dotfiles_root/sh/run/ffmpeg-record" "$HOME/.local/bin/ffmpeg-record"
install_link "$dotfiles_root/sh/run/record.sh" "$HOME/.local/bin/record.sh"
install_link "$dotfiles_root/.config/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"

if command -v powershell.exe >/dev/null 2>&1; then
  ps_recorder="$dotfiles_root/sh/ps1/ffmpeg-screen-record.ps1"
  if command -v cygpath >/dev/null 2>&1; then
    ps_recorder="$(cygpath -w "$ps_recorder")"
  fi

  echo
  echo "Windows FFmpeg audio devices:"
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$ps_recorder" -ListAudioDevices || true
fi

cat <<'EOF'

Done.
Screen recordings save to Videos.
Windows/whkd shortcut: Super + Alt + J.
Hyprland shortcut: Super + Alt + J.

Audio defaults:
- Windows records the first DirectShow audio device, preferring loopback-style devices such as Stereo Mix when available.
- Hyprland records the default sink monitor when pactl is available, then falls back to wf-recorder --audio.
- Set SCREEN_RECORD_AUDIO_DEVICE on Windows or SCREEN_RECORD_AUDIO_SOURCE on Linux to force a specific audio source.
- Set SCREEN_RECORD_AUDIO=0 for Linux recorders, or pass -NoAudio to the PowerShell recorder, to record video only.
EOF
