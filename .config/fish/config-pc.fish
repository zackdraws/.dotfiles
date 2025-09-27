# Suppress greeting
set -U fish_greeting

# oh-my-posh and zoxide
oh-my-posh init fish --config ~/.config/oh-my-posh/themes/emodipt-extend.omp.json | source
zoxide init fish | source

# Environment variables
set -gx GDK_SCALE 2
set -gx TERM xterm-256color
set -gx COLORTERM truecolor
set -gx YAZI_PREVIEW_IMAGE_PROTOCOL chafa  # fixed typo: PRORTOCOL -> PROTOCOL

# Aliases
alias se="sudo $EDITOR"
alias ghostty='cd ~/Projects/ghostty && ./zig-out/bin/ghostty &'
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
alias dotodo="mkto.sh"
alias yt="mov-cli -s youtube.yt-dlp"
alias ytd="mov-cli -s youtube.yt-dlp -d"

# Set default editor to emacsclient
set -gx EDITOR "emacsclient -n"

# Function: open emacs in terminal
function e
    emacs -nw $argv
end

function watch-clipboard --description "Automatically convert Windows paths in clipboard to POSIX format"
    set -l last ""

    while true
        set current (powershell.exe -NoProfile -Command Get-Clipboard | tr -d '\r')

        if test "$current" = "$last" -o -z "$current"
            sleep 0.4
            continue
        end

        set last "$current"

        # Match Windows paths like C:\something
        if string match -rq "^[A-Za-z]:\\\\" -- $current
            set path (string replace -a '\\' '/' $current)
            set drive (string lower (string sub -l 1 $path))
            set rest (string sub -s 3 $path)
            set unixpath "/$drive/$rest"

            echo $unixpath | clip.exe
            echo "✅ Converted clipboard path: $unixpath"
        end

        sleep 0.4
    end
end
