set -gx EDITOR emacs -nw
alias e=$EDITORS
# alias se="sudo $EDITOR"
# alias ghostty='cd ~/Projects/ghostty && ./zig-out/bin/ghostty &'
# alias deldoop="delete_duplicate_images.sh"
# alias sync="syncthing.sh"
# alias dotodo="mkto.sh"
# alias yt="mov-cli -s youtube.yt-dlp"
# alias ytd="mov-cli -s youtube.yt-dlp -d"
zoxide init fish | source
set -gx GDK_SCALE 2 #GWSL
set -gx TERM xterm-256color
set -gx COLORTERM truecolor
set -gx YAZI_PREVIEW_IMAGE_PRORTOCOL chafa
function e
    emacs -nw $argv
end

oh-my-posh init fish --config ~/.config/oh-my-posh/themes/honukai.omp.json | source

set -x ANDROID_HOME ~/Android
set -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator $PATH
set -x ANDROID_HOME ~/Android/Sdk
set -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator $PATH

set -x PATH $HOME/.local/kitty.app/bin $PATH
set -gx EDITOR emacs -nw
alias e=$EDITORS
## alias se="sudo $EDITOR"
## alias ghostty='cd ~/Projects/ghostty && ./zig-out/bin/ghostty &'
## alias deldoop="delete_duplicate_images.sh"
## alias y="yazi"
## alias psd_c="psd_convert.sh"
## alias psd_j="psd_jpeg.sh"
## alias tv="irssi.sh"
## alias jfif_j="jfif_jpeg.sh"
## alias copy_txt="copy_clip.sh"
## alias compress_v="compress_video.sh"
## alias sync="syncthing.sh"
alias ok="TODO.sh"
## alias dotodo="mkto.sh"
## alias yt="mov-cli -s youtube.yt-dlp"
## alias ytd="mov-cli -s youtube.yt-dlp -d"
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
## alias ok="TODO.sh"
alias dotodo="mkto.sh"
alias yt="mov-cli -s youtube.yt-dlp"
alias ytd="mov-cli -s youtube.yt-dlp -d"
zoxide init fish | source
set -gx GDK_SCALE 2 #GWSL
set -gx TERM xterm-256color
set -gx COLORTERM truecolor
set -gx YAZI_PREVIEW_IMAGE_PRORTOCOL chafa
function e

    emacs -nw $argv

end

set -x ANDROID_HOME ~/Android
set -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator $PATH
set -x ANDROID_HOME ~/Android/Sdk
set -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator $PATH

set -x PATH $HOME/.local/kitty.app/bin $PATH
set -gx YAZI_FILE_ONE "C:\\Program Files\\Git\\usr\\bin\\file.exe"


function watch-clipboard --description "Automatically convert Windows paths in clipboard to MSYS paths"
    set -l last ""

    while true
        # Get clipboard content
        set current (powershell.exe -NoProfile -Command Get-Clipboard | tr -d '\r')

        # Skip if unchanged or empty
        if test "$current" = "$last" -o -z "$current"
            sleep 0.5
            continue
        end

        set last "$current"

        # Check if path looks like C:\... (starts with drive letter and colon and backslash)
        if test (string length $current) -gt 3
            set first_char (string sub -l 1 $current)
            set second_char (string sub -s 2 -l 1 $current)
            set third_char (string sub -s 3 -l 1 $current)

            if string match -rq '[A-Za-z]' -- $first_char
                and test $second_char = ":"
                and test $third_char = "\\"
                    # Convert to /c/Users/... style
                    set path (string replace -a '\\' '/' $current)
                    set drive (string lower $first_char)
                    set rest (string sub -s 4 $path)
                    set unixpath "/$drive/$rest"

                    # Update clipboard
                    echo $unixpath | clip.exe
                    echo "✅ Converted clipboard path: $unixpath"
            end
        end

        sleep 0.5
    end
end
