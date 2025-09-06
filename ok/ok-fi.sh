#!/bin/bash



set -e



echo "▶ Setting up for UNIX-based system..."



# Detect OS

OS="$(uname)"

IS_MAC=false

IS_LINUX=false



if [[ "$OS" == "Darwin" ]]; then

    IS_MAC=true

elif [[ "$OS" == "Linux" ]]; then

    IS_LINUX=true

else

    echo "❌ Unsupported OS: $OS"

    exit 1

fi



# --- Install Powerline or Nerd Fonts ---

echo "▶ Installing fonts for powerline support..."



if $IS_LINUX; then

    if command -v apt &> /dev/null; then

        sudo apt update

        sudo apt install -y fonts-powerline

    elif command -v pacman &> /dev/null; then

        sudo pacman -S --noconfirm ttf-dejavu ttf-hack ttf-nerd-fonts-symbols

    else

        echo "⚠ Please manually install a Nerd Font. Skipping font install."

    fi

elif $IS_MAC; then

    if ! command -v brew &> /dev/null; then

        echo "❌ Homebrew not found. Install it from https://brew.sh"

        exit 1

    fi

    brew tap homebrew/cask-fonts

    brew install --cask font-hack-nerd-font

fi



# --- Install Oh My Fish ---

echo "▶ Installing Oh My Fish..."

curl -L https://get.oh-my.fish | fish



# --- Install bobthefish Theme ---

echo "▶ Installing bobthefish theme..."

fish -c "omf install bobthefish"



# --- Configure ~/.config/fish/config.fish ---

echo "▶ Writing Fish config..."



FISH_CONFIG="$HOME/.config/fish/config.fish"

mkdir -p "$(dirname "$FISH_CONFIG")"



cat > "$FISH_CONFIG" <<'EOF'

# --- bobthefish boxed prompt settings ---

set -g theme_display_user yes

set -g theme_display_hostname yes

set -g theme_display_pwd full

set -g theme_nerd_fonts yes

set -g theme_powerline_fonts yes



# --- Environment Variables ---

set -gx EDITOR emacs -nw

set -gx GDK_SCALE 2

set -gx TERM xterm-256color

set -gx COLORTERM truecolor

set -gx YAZI_PREVIEW_IMAGE_PROTOCOL chafa



# --- Kitty Terminal (if installed) ---

set -x PATH $HOME/.local/kitty.app/bin $PATH



# --- Zoxide (fast directory jumper) ---

zoxide init fish | source



# --- Aliases ---

alias se="sudo \$EDITOR"

alias ghostty='cd ~/Projects/ghostty && ./zig-out/bin/ghostty &'

alias gh="zig-out/bin/ghostty"

alias g="z ghostty ghostty"

alias deldoop="delete_duplicate_images.sh"

alias y="yazi"

alias 0T5="TODO.sh"

alias psd_c="psd_convert.sh"

alias psd_j="psd_jpeg.sh"

alias tv="irssi.sh"

alias jfif_j="jfif_jpeg.sh"

alias copy_txt="copy_clip.sh"

alias compress_v="compress_video.sh"

alias sync="syncthing.sh"

alias ok="TODO.sh"

alias dotodo="mkto.sh"

alias yt="mov-cli -s youtube.yt-dlp"

alias ytd="mov-cli -s youtube.yt-dlp -d"

alias ze="zellij"



# --- Function: e ---

function e

    emacs -nw $argv

end

EOF



# --- Done ---

echo "✅ Setup complete!"

echo "👉 Restart your terminal or run: source ~/.config/fish/config.fish"

echo "👉 Make sure your terminal font is set to a Nerd Font (e.g., Hack, MesloLGS NF)"
