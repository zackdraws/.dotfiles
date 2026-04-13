# set time
sudo timedatectl set-timezone America/Los_Angeles
# install
pacman -S git curl emacs discord syncthing tmux wofi wlroots xdg-desktop-portal-hyprland ncdu xbindkeys xdotool keyd
yay -S interception-tools interception-keyboard
sudo systemctl enable --now keyd
#set-up emacs
cp ~/.dotfiles/emacs/.emacs ~/.emacs
mkdir ~/.ok/ok/
chsh -s $(which fish)
# fonts and pdf
sudo pacman -S xelatex
sudo pacman -S ttf-dejavu
mkdir /usr/share/fonts/truetype/dejavus 
ln -s /usr/share/fonts/TTF/DejaVuSans.ttf /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf
pacman -S python-pillow
pacman -S pandoc imagemagick
yay -S sioyek python-fpdf 
# finance
sudo pacman -S hledger
pipx install hledger-utils
yay -S pup
# monitor system
pacman -S htop btop
# tmux tpm plug-ins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#dvd-
sudo pacman -S libdvdnav
sudo pacman -S libdvdcss
sudo pacman -S libdvdread
# cmd to play dvd
# mpv dvd://
paru -S google-chrome
sudo apt install build-essential pkg-config libgmime-3.0-dev libxapian-dev libsqlite3-dev libgpgme-dev libglib2.0-dev
pacman -S imv
