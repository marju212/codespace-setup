# Custom bash aliases and functions

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -la'
alias la='ls -A'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline -20'
alias glog='git log --oneline --graph --decorate'

alias cl="claude --dangerously-skip-permissions"

# Git functions
gac() {
    git add --all && git commit -m "$1"
}

gacp() {
    git add --all && git commit -m "$1" && git push
}
