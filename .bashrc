-gx PATH $PATH /usr/bin /bin


set -g history_save_dir $XDG_DATA_HOME/fish/fish_history

set -g history_max 2000



# Fish automatically handles window size updates, no need for `shopt -s checkwinsize`



# Set up "lesspipe" for non-text files (Fish handles this differently)

if test -x /usr/bin/lesspipe

    lesspipe | source

end



# Check if debian_chroot is set and read /etc/debian_chroot if necessary

if not set -q debian_chroot

    and test -r /etc/debian_chroot

    set debian_chroot (cat /etc/debian_chroot)

end



# Set a fancy prompt (non-color, unless we know we "want" color)

switch $TERM

    case 'xterm-color' '*-256color'

        set -g color_prompt yes

end



# Force color prompt if applicable

if test -n "$color_prompt"

    if test -x /usr/bin/tput

        set -g color_prompt yes

    else

        set -g color_prompt ""

    end

end



# Set the PS1 variable for the prompt

if test "$color_prompt" = "yes"

    set -g PS1 '\u@\h:w\$ '

else

    set -g PS1 '${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

end



# Set the terminal title for xterm

switch $TERM

    case 'xterm*' 'rxvt*'

       

end



# Enable color support for `ls` and other commands

if test -x /usr/bin/dircolors

    if test -r ~/.dircolors

        eval (dircolors -b ~/.dircolors)

    else

        eval (dircolors -b)

    end

    alias ls="ls --color=auto"

    alias grep="grep --color=auto"

    alias fgrep="fgrep --color=auto"

    alias egrep="egrep --color=auto"

end



# Set some aliases for ls commands

alias ll='ls -alF'

alias la='ls -A'

alias l='ls -CF'



# Add an "alert" alias for long-running commands. Use like so:

#   sleep 10; alert




# Source your aliases if they exist

if test -f ~/.fish_aliases

    source ~/.fish_aliases

end



# Enable programmable completion features (Fish handles this automatically)

# If not enabled, you can enable Fish's built-in completions



# Source fzf if available

if test -f ~/.fzf.fish

    source ~/.fzf.fish

end



# Source rust/cargo environment if applicable

if test -f "$HOME/.cargo/env"

    source $HOME/.cargo/env

end



# Alias to open TVPaint (if script exists)

alias opentvpaint='~/open_tvpaint.sh'



# Initialize zoxide for Fish shell

eval (zoxide init fish)



# Source broot launcher if available

if test -f /home/zack/.config/broot/launcher/fish/br

    source /home/zack/.config/broot/launcher/fish/br

end



# Set PKG_CONFIG_PATH if needed

set -gx PKG_CONFIG_PATH /usr/local/lib/pkgconfig $PKG_CONFIG_PATH



# Set GDK_SCALE, DISPLAY, and PulseAudio environment variables (for GWSL)

set -gx GDK_SCALE 2

set -gx DISPLAY (awk '/nameserver/ {print $2; exit}' /etc/resolv.conf):0.0

set -gx PULSE_SERVER "tcp:(awk '/nameserver/ {print $2; exit}' /etc/resolv.conf)"

set -gx LIBGL_ALWAYS_INDIRECT 1

set -gx DISPLAY localhost:0

