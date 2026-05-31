#!/bin/sh
# iSH / iPhone setup for this dotfiles repo.
# Run from iSH with:
#   sh ~/.dotfiles/ok/ok-iphone.sh

set -u

log() {
    printf '\n==> %s\n' "$*"
}

warn() {
    printf '!! %s\n' "$*" >&2
}

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
DOTFILES=${DOTFILES:-$(CDPATH= cd "$SCRIPT_DIR/.." && pwd -P)}
CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
LOCAL_BIN="$HOME/.local/bin"
STAMP=$(date +%Y%m%d%H%M%S)

if [ ! -d "$DOTFILES/.config/emacs/emacs-ish" ]; then
    warn "Cannot find $DOTFILES/.config/emacs/emacs-ish"
    warn "Clone this repo to ~/.dotfiles first, or run with DOTFILES=/path/to/.dotfiles."
    exit 1
fi

install_apk_package() {
    pkg=$1
    if apk info -e "$pkg" >/dev/null 2>&1; then
        return 0
    fi

    if apk add --no-cache "$pkg"; then
        return 0
    fi

    warn "Could not install apk package: $pkg"
    return 1
}

backup_path() {
    path=$1
    if [ -L "$path" ]; then
        rm -f "$path"
    elif [ -e "$path" ]; then
        mv "$path" "$path.bak.$STAMP"
        warn "Backed up $path to $path.bak.$STAMP"
    fi
}

link_file() {
    src=$1
    dest=$2

    if [ ! -e "$src" ]; then
        warn "Missing source, skipped: $src"
        return 0
    fi

    mkdir -p "$(dirname "$dest")"
    backup_path "$dest"

    if ln -s "$src" "$dest" 2>/dev/null; then
        return 0
    fi

    cp "$src" "$dest"
    warn "Symlink failed, copied instead: $dest"
}

link_bin() {
    rel=$1
    src="$DOTFILES/$rel"
    dest="$LOCAL_BIN/$(basename "$rel")"

    if [ ! -e "$src" ]; then
        warn "Missing script, skipped: $rel"
        return 0
    fi

    chmod +x "$src" 2>/dev/null || true
    link_file "$src" "$dest"
}

ensure_source_line() {
    file=$1
    line=$2

    mkdir -p "$(dirname "$file")"
    touch "$file"
    if ! grep -Fqx "$line" "$file" 2>/dev/null; then
        printf '\n%s\n' "$line" >> "$file"
    fi
}

log "Installing iSH packages"
if command -v apk >/dev/null 2>&1; then
    apk update || warn "apk update failed; continuing with available indexes"

    for pkg in \
        ca-certificates \
        git \
        curl \
        openssh-client \
        emacs \
        tmux \
        fish \
        less \
        coreutils \
        findutils \
        grep \
        sed \
        gawk
    do
        install_apk_package "$pkg" || true
    done

    for pkg in \
        yazi \
        syncthing \
        pandoc \
        fzf \
        ripgrep \
        fd \
        bat \
        ncdu \
        python3 \
        py3-pip \
        ffmpeg \
        imagemagick \
        github-cli
    do
        install_apk_package "$pkg" || true
    done

    if command -v update-ca-certificates >/dev/null 2>&1; then
        update-ca-certificates || true
    fi
else
    warn "apk was not found. This script is meant for iSH/Alpine."
fi

log "Creating iSH folders"
mkdir -p \
    "$HOME/.emacs.d" \
    "$HOME/.ok/ok" \
    "$HOME/ok" \
    "$HOME/ref" \
    "$HOME/music" \
    "$HOME/Videos" \
    "$HOME/2026" \
    "$CONFIG_HOME/fish" \
    "$CONFIG_HOME/yazi" \
    "$LOCAL_BIN"

log "Linking terminal configs"
link_file "$DOTFILES/.config/bash/.bashrc-ish" "$HOME/.bashrc-ish"
link_file "$DOTFILES/.config/fish/config-ish.fish" "$CONFIG_HOME/fish/config.fish"
link_file "$DOTFILES/.config/tmux/tmux-ish.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES/.config/yazi/yazi-ish.toml" "$CONFIG_HOME/yazi/yazi.toml"

PROFILE_LINE="[ -f \"$HOME/.bashrc-ish\" ] && . \"$HOME/.bashrc-ish\""
ensure_source_line "$HOME/.profile" "$PROFILE_LINE"
ensure_source_line "$HOME/.bashrc" "$PROFILE_LINE"

log "Linking Emacs iSH config"
link_file "$DOTFILES/.config/emacs/emacs-ish/init.el" "$HOME/.emacs"
link_file "$DOTFILES/.config/emacs/emacs-ish/init.el" "$HOME/.emacs.d/init.el"

log "Linking phone-friendly helper scripts into ~/.local/bin"
for rel in \
    sh/make/mkto.sh \
    sh/convert/cnv_org_docx.sh \
    sh/export/export_org_to_pdf.sh \
    sh/export/export_org_to_pdf_02.sh \
    sh/format/to_latex.sh \
    sh/format/bracket_format.sh \
    sh/format/grep_t.sh \
    sh/format/grep_thumbnails.sh \
    sh/convert/untar.sh \
    sh/convert/cnv_jpg_pdf.sh \
    sh/convert/cnv_pdf_jpg.sh \
    sh/convert/cnv_pdf__jpg.sh \
    sh/convert/cnv_m4a_mp3.sh \
    sh/convert/cnv_mp4_gif.sh \
    sh/convert/cnv_mp4_frames.sh \
    sh/convert/cnv_png_j.sh \
    sh/convert/cnv_webp_jpeg.sh \
    sh/convert/jfif_jpeg.sh \
    sh/rename/rename.sh \
    sh/rename/F2.sh \
    sh/rename/F2_date_taken.sh \
    sh/rename/F2_folder.sh \
    sh/shell_files/move_files_to_parent.sh \
    sh/file/filepath.sh \
    sh/file/FI_^^.sh \
    py/download-video-page.py
do
    link_bin "$rel"
done

cat <<EOF

Done.

Open a new iSH session, or reload this one:
  . ~/.profile

Start Emacs:
  emacs -nw

Inside Emacs, optional package install:
  M-x ok-install-phone-packages

Notes and agenda files live in:
  ~/.ok/ok
EOF
