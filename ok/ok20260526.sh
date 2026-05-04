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

echo "ensure fish is in /etc/shells"
command -v fish | sudo tee -a /etc/shells || true

echo "set default shell to fish"
chsh -s "$(command -v fish)" || true

echo "install scoop (PowerShell)"
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command \
"if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) { iwr -useb get.scoop.sh | iex }"
