#!/usr/bin/env bash
set -e

echo "link from .dotfiles to tvpaint config"
ln -sf /c/.dotfiles/tvp/20250403_ok.cfg "/c/users/zacha/AppData/Roaming/tvp animation 11 pro/default/config.ini"

echo "link from .dotfiles to emacs"
ln -sf ~/.dotfiles/emacs/.emacs ~/.emacs.d/init.el

echo "update system"
pacman -Syu --noconfirm

echo "install core packages"
pacman -S --needed --noconfirm \
  base-devel git fzf fish gh yazi syncthing wget curl unzip zip tar \
  neovim htop ripgrep fd bat jq tree tmux zoxide lazygit glow xclip mpv

echo "install UCRT packages"
pacman -S --needed \
  mingw-w64-ucrt-x86_64-oh-my-posh \
  mingw-w64-ucrt-x86_64-yazi \
  mingw-w64-ucrt-x86_64-ttf-firacode-nerd \
  mingw-w64-ucrt-x86_64-github-cli \
  mingw-w64-ucrt-x86_64-python \
  mingw-w64-ucrt-x86_64-toolchain \
  mingw-w64-ucrt-x86_64-chromaprint \
  mingw-w64-ucrt-x86_64-ffmpeg \
  mingw-w64-ucrt-x86_64-libffi \
  mingw-w64-ucrt-x86_64-libyaml \
  mingw-w64-ucrt-x86_64-texlive-bin \
  mingw-w64-ucrt-x86_64-texlive-core \
  mingw-w64-ucrt-x86_64-texlive-luatex \
  mingw-w64-ucrt-x86_64-texlive-latex-recommended \
  mingw-w64-ucrt-x86_64-texlive-latex-extra \
  mingw-w64-ucrt-x86_64-gcc \
  mingw-w64-ucrt-x86_64-libevent \
  mingw-w64-ucrt-x86_64-ncurses

echo "install beets"
python -m pip install 'beets[fetchart,lyrics,lastgenre,ftintitle,chromaprint]'

echo "clone oh-my-posh"
git clone https://github.com/JanDeDobbeleer/oh-my-posh.git || true

# foobar2000
DOWNLOADS_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOADS_DIR"
cd "$DOWNLOADS_DIR"

echo "Downloading foobar2000..."
curl -LO https://www.foobar2000.org/files/foobar2000_v2.1.exe
cmd.exe /C start foobar2000_v2.1.exe

# Zen browser (optional)
ZEN_BROWSER_URL=""
if [ -n "$ZEN_BROWSER_URL" ]; then
  if curl --output zenbrowser_installer.exe --location --fail "$ZEN_BROWSER_URL"; then
    cmd.exe /C start zenbrowser_installer.exe
  else
    echo "Zen Browser download failed"
  fi
fi

echo "ensure fish is in /etc/shells"
command -v fish | sudo tee -a /etc/shells || true

echo "set default shell to fish"
chsh -s "$(command -v fish)" || true

echo "install scoop (PowerShell)"
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command \
"if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) { iwr -useb get.scoop.sh | iex }"
