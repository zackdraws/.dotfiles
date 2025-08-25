function nnn-preview
    if test "$NNNLVL" -ge 1
        echo "nnn is already running"
        return
    end

    set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
    set -x NNN_FIFO (mktemp -u --suffix=-nnn)
    mkfifo $NNN_FIFO
    chmod 600 $NNN_FIFO

    set preview_cmd "$HOME/.config/nnn/preview_cmd.sh"

    if set -q TMUX
        tmux split-window -e NNN_FIFO=$NNN_FIFO -dh $preview_cmd
    else if type -q xterm
        xterm -e $preview_cmd &
    else
        echo "Please install tmux or xterm for live preview"
    end

    nnn $argv

    rm -f $NNN_FIFO
end
