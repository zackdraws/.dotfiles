pacman -S git
pacman -S emacs
cp ~/.dotfiles/emacs/.emacs ~/.emacs
pacman -S syncthing
mkdir ~/.ok/ok/
pacman -S pandoc
pacman -S curl
pacman -S tmux
chsh -s $(which fish)
pacman -S wofi wlroots xdg-desktop-portal-hyprland
sudo pacman -S ncdu
pacman -S xbindkeys xdotool
pacman -S interception-tools
yay -S interception-tools interception-keyboard
sudo pacman -S keyd
sudo systemctl enable --now keyd
sudo timedatectl set-timezone America/Los_Angeles
