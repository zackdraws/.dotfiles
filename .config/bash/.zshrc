export ZSH="HOME/.oh-my-zsh"
export EDITOR="emacs -nw"
set ZSH_THEME= "strug"
set plugins(git)
source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
source /home/zack/.config/broot/launcher/bash/br
export PATH=$PATH:/snap/bin
alias ghostty ="/home/zack/ghostty/ghostty/zig-out/bin/ghostty"
