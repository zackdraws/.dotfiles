# iSH / iPhone fish config.

set -gx EDITOR "emacs -nw"
set -gx VISUAL "emacs -nw"
set -gx PAGER less
set -gx LESS -R
set -gx COLORTERM truecolor

if not set -q TERM
    set -gx TERM xterm-256color
end

if functions -q fish_add_path
    fish_add_path -g ~/.local/bin
else if not contains ~/.local/bin $PATH
    set -gx PATH ~/.local/bin $PATH
end

set -U fish_greeting

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias se='emacs -nw'

if command -q yazi
    alias y='yazi'
end

function e
    emacs -nw $argv
end

function ok
    mkdir -p ~/.ok/ok
    emacs -nw ~/.ok/ok/(date +%Y%m%d%H%M).org
end

function mkcd
    mkdir -p $argv[1]
    and cd $argv[1]
end

if command -q zoxide
    zoxide init fish | source
end
