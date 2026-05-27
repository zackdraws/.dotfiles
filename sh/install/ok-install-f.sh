#!/bin/bash
set -e
echo "▶ Installing Powerline fonts..."
# Install powerline fonts
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install -y fonts-powerline
    else
        echo "⚠ Skipping font install: 'apt' not found."
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font
fi
echo "▶ Installing Oh My Fish..."
curl -L https://get.oh-my.fish | fish
echo "▶ Installing bobthefish theme..."
fish -c "omf install bobthefish"
echo "▶ Creating Fish config with boxed bobthefish..."
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
if status is-interactive
    stty -ixon 2>/dev/null
end
set -gx EDITOR emacs -nw
set -gx GDK_SCALE 2
if test "$MSYSTEM" = UCRT64; and not set -q TMUX; and not set -q TERM
    set -gx TERM xterm-256color
end
set -gx COLORTERM truecolor
if test "$MSYSTEM" = UCRT64; and test "$MSYSCON" = mintty.exe
    if begin; not set -q TERM_PROGRAM; or test "$TERM_PROGRAM" = tmux; end
        set -gx TERM_PROGRAM mintty
    end
end
# --- Kitty Terminal ---
set -x PATH $HOME/.local/kitty.app/bin $PATH
# --- Zoxide ---
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
echo "✅ Setup complete!"
echo "👉 Restart your terminal or run: source ~/.config/fish/config.fish"
echo "👉 Set your terminal font to a Powerline or Nerd Font (e.g., Hack, FiraCode, MesloLGS NF)"
