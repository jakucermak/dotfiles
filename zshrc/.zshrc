# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    npm
)

source $ZSH/oh-my-zsh.sh

#Aliases

## Git Aliases

alias gs="git status"
alias ga="git add"
alias gcm="git commit -m"

alias pip="pip3"
alias rr=". ranger"
alias ls="lsd"
alias py="python3"
alias ssh='TERM=xterm-256color ssh'

vncparams=(
"-ColorLevel=full"
"-WarnUnencrypted=0"
"-SendSpecialKeys=0"
"-Scaling=AspectFit"
)

alias vncviewer="/nix/store/3l40allr06rscvnigaxk0wml7ryz7rms-realvnc-vnc-viewer-7.12.1/Applications/VNC\ Viewer.app/Contents/MacOS/vncviewer"

function hugvnc() {
    echo ${vncparams[@]}

    vncviewer "${1}" ${vncparams[@]} -passwordFile ~/passwd
}



case `uname` in

    Darwin)
        alias cat="bat"
	alias st="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl --launch-or-new-window"
	alias nv="/Applications/Neovide.app/Contents/MacOS/neovide"
	export PATH="/opt/homebrew/opt/flex/bin:$PATH"
	export PATH="/opt/homebrew/opt/bison/bin:$PATH"
        ;;
    Linux)
        alias cat="batcat"
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
 exec tmux new -As tmux
fi
        ;;
esac


#Functions
function catdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

function mkcd() {
    mkdir -p "$@" && cd "$_";
}


_ssh()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)

    COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    return 0
}
complete -F _ssh ssh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

export PATH=$PATH:~/.local/bin

# pnpm
export PNPM_HOME="/Users/jakubcermak/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#

export PATH="/opt/homebrew/opt/ansible@9/bin:$PATH"

# precmd () {
#     tmux set -qg status-left "#S #P $(pwd)"
# }
