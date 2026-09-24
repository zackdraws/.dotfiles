# set time
sudo timedatectl set-timezone America/Los_Angeles
# install programs
sudo chmod +X ./~/.dotfiles/sh/install/install-arch-software
sudo ln -s ~/.dotfiles/sh/install/install-arch-software /usr/local/bin/
./home/user/ok/.dotfiles/sh/install/install-arch-software
#set-up emacs
cp ~/.dotfiles/emacs/.emacs ~/.emacs
mkdir ~/.ok/ok/
# fish
chsh -s $(which fish)
# fonts and pdf
mkdir /usr/share/fonts/truetype/dejavus 
ln -s /usr/share/fonts/TTF/DejaVuSans.ttf /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf
# tmux tpm plug-ins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#dvd-
# cmd to play dvd
# mpv dvd://
