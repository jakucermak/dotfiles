#Functions
function catdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

function mkcd() {
    mkdir -p "$@" && cd "$_";
}



eval "$(starship init zsh)"

#Aliases
alias python="python3"
alias pip="pip3"
alias rr=". ranger"
alias ls="lsd"
alias vim="nvim"
