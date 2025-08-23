set -gx EDITOR emacs -nw
set -gx PATH $PATH /home/zack/.local/bin
set -Ux PATH $PATH /home/zack/.local/bin
alias e=$EDITORS
alias record="ffmpeg.exe -y -f gdigrab -framerate 30 -i desktop "$(wslpath =w $HOME)/zpf3.mp4"
alias copydir="xsel -b"
alias se="sudo $EDITOR"
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
alias todo="mkto.sh"
alias yt="mov-cli -s youtube.yt-dlp"
alias ytd="mov-cli -s youtube.yt-dlp -d"

zoxide init fish | source
set -gx GDK_SCALE 2 #GWSL

function e

    emacs -nw $argv

end
