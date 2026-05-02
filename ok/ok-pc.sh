#!/usr/bin/bash
set -e
echo "link from .dotfiles to tvpaint config"
ln -s /c/.dotfiles/tvp/20250403_ok.cfg /c/users/zacha/AppData/Roaming/tvp\ animation\ 11\ pro/default/config.ini
echo "link from .dotfiles to emacs"
ln -s ~/.dotfiles/emacs/.emacs ~/.emacs.d/init.el
echo "download oh-my-posh and fonts"
pacman -S mingw-w64-ucrt-x86_64-oh-my-posh mingw-w64-ucrt-x86_64-yazi mingw-w64-ucrt-x86_64-ttf-firacode-nerd
cd ~/
git clone https://github.com/JanDeDobbeleer/oh-my-posh.git
pacman -Syu --noconfirm
pacman -S --noconfirm mpv
pacman -S --needed base-devel git fzf fish gh yazi syncthing wget curl unzip zip tar neovim htop ripgrep fd bat jq tree tmux zoxide lazygit glow xclip bat ripgrep fd
echo "github cli, python, toolchain, chromaprint, ffmpeg, libffi, and libyaml"
pacman -S mingw-w64-ucrt-x86_64-github-cli mingw-w64-ucrt-x86_64-python
pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
pacman -S --needed mingw-w64-ucrt-x86_64-chromaprint mingw-w64-ucrt-x86_64-ffmpeg mingw-w64-ucrt-x86_64-libffi mingw-w64-ucrt-x86_64-libyaml mingw-w64-ucrt-x86_64-mpv mingw-w64-ucrt-x86_64-fzf  mingw-w64-ucrt-x86_64-vlc mingw-w64-ucrt-x86_64-github-cli irssi #
echo "install beets, tex"
pip install 'beets[fetchart,lyrics,lastgenre,ftintitle,chromaprint]'
pacman -S mingw-w64-ucrt-x86_64-texlive-bin \
        mingw-w64-ucrt-x86_64-texlive-core \
        mingw-w64-ucrt-x86_64-texlive-luatex \
        mingw-w64-ucrt-x86_64-texlive-latex-recommended \
        mingw-w64-ucrt-x86_64-texlive-latex-extra
pacman -S mingw-w64-ucrt-x86_64-gcc \
             mingw-w64-ucrt-x86_64-libevent mingw-w64-ucrt-x86_64-ncurses \
# Add fish to /etc/shells if it's not there
command -v fish | sudo tee -a /etc/shells
echo  "Change default shell to fish"
chsh -s /usr/bin/fish
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command 
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    iwr -useb get.scoop.sh | iex
# winget
winget install VideoLAN.VLC
winget install google.chrome
winget mpv
winget vlc
# scoop
* scoop bucket add extreas
- scoop install extras/mpv
# controller driver from sony
curl -L "https://fwupdater.dl.playstation.net/fwupdater/PlayStationAccessoriesInstaller.exe" ^
-o "C://users/ok/Downloads/"
winget install AppWork.JDownloader
