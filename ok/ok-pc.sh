#!/usr/bin/bash
set -e
echo "==> Updating pacman packages..."
pacman -Syu --noconfirm
echo "==> Installing mutt and mpv..."
pacman -S --noconfirm mutt mpv
# Set up download directory
DOWNLOADS_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOADS_DIR"
cd "$DOWNLOADS_DIR"
echo "==> Downloading foobar2000 installer..."
curl -LO https://www.foobar2000.org/files/foobar2000_v2.1.exe
echo "==> Launching foobar2000 installer..."
cmd.exe /C start foobar2000_v2.1.exe
# Zen Browser placeholder
ZEN_BROWSER_URL="https://example.com/zenbrowser_installer.exe"  # Replace with actual URL if known
echo "==> Downloading Zen Browser (if available)..."
if curl --output zenbrowser_installer.exe --location --fail "$ZEN_BROWSER_URL"; then
    echo "==> Launching Zen Browser installer..."
    cmd.exe /C start zenbrowser_installer.exe
else
    echo "==> Zen Browser URL not valid or not provided."
    echo "    Please update the script with a valid Zen Browser download link."
fi
echo "==> All done."
# Basic packages
pacman -S --needed base-devel git fzf fish gh yazi syncthing wget curl unzip zip tar
# Optional but useful
pacman -S neovim htop ripgrep fd bat jq tree tmux zoxide lazygit glow xclip bat ripgrep fd
# Add fish to /etc/shells if it's not there
command -v fish | sudo tee -a /etc/shells
# Change default shell to fish
chsh -s /usr/bin/fish
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command "
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    iwr -useb get.scoop.sh | iex
}
pacman -S mingw-w64-ucrt-x86_64-github-cli
pacman -S mingw-w64-ucrt-x86_64-python
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
pacman -S --needed mingw-w64-ucrt-x86_64-chromaprint \
                     mingw-w64-ucrt-x86_64-ffmpeg \
                     mingw-w64-ucrt-x86_64-libffi \
                     mingw-w64-ucrt-x86_64-libyaml
pip install 'beets[fetchart,lyrics,lastgenre,ftintitle,chromaprint]'

pacman -S mingw-w64-ucrt-x86_64-texlive-bin \

        mingw-w64-ucrt-x86_64-texlive-core \

        mingw-w64-ucrt-x86_64-texlive-luatex \

        mingw-w64-ucrt-x86_64-texlive-latex-recommended \

        mingw-w64-ucrt-x86_64-texlive-latex-extra

pacman -Syu
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-toolchain \
             mingw-w64-ucrt-x86_64-libevent mingw-w64-ucrt-x86_64-ncurses
pacman -S mingw-w64-ucrt-x86_64-ttf-firacode-nerd
ln -s ~/.dotfiles/emacs/.emacs ~/.emacs.d/init.el
pacman -S mingw-w64-ucrt-x86_64-oh-my-posh
git clone https://github.com/JanDeDobbeleer/oh-my-posh.git
pacman -S mingw-w64-ucrt-x86_64-yazi
ln -s /c/.dotfiles/tvp/20250403_ok.cfg /c/users/zacha/AppData/Roaming/tvp\ animation\ 11\ pro/default/config.ini
