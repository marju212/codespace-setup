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

# shellcheck disable=SC2139
alias cl="$HOME/.local/bin/claude --dangerously-skip-permissions"

# Dotfiles
alias dotup='git -C ~/.dotfiles pull && source ~/.bash_aliases && echo "Dotfiles updated!"'

# Template management
use-template() {
    local template="$1"
    if [ -z "$template" ]; then
        echo "Available templates:" && ls ~/.dotfiles/templates/ 2>/dev/null
        echo "" && echo "Usage: use-template <name>"
        return 1
    fi
    local src="$HOME/.dotfiles/templates/$template"
    if [ ! -e "$src" ]; then
        echo "Template not found: $template" && return 1
    fi
    rm -rf .devcontainer
    if [ -d "$src" ]; then
        cp -r "$src" .devcontainer
    else
        mkdir -p .devcontainer
        cp "$src" .devcontainer/devcontainer.json
    fi
    echo "Template '$template' applied to .devcontainer/"
    echo "Rebuild the Codespace: F1 > Codespaces: Rebuild Container"
}

# MCP management
mcp-merge() {
    local src="${1:-.devcontainer/claude-settings.json}"
    local dest=".claude/settings.json"
    if [ ! -f "$src" ]; then
        echo "Source not found: $src" && return 1
    fi
    mkdir -p .claude
    if [ -f "$dest" ]; then
        jq -s '.[0] * {mcpServers: (.[0].mcpServers // {} ) * (.[1].mcpServers // {})}' "$dest" "$src" > "$dest.tmp" \
            && mv "$dest.tmp" "$dest" \
            && echo "Merged MCP servers from $src into $dest"
    else
        cp "$src" "$dest"
        echo "Created $dest from $src"
    fi
}

mcp-list() {
    local settings=".claude/settings.json"
    if [ -f "$settings" ]; then
        echo "Project MCPs:" && jq -r '.mcpServers // {} | keys[]' "$settings" 2>/dev/null
    else
        echo "No project MCP config found"
    fi
    local global="$HOME/.claude/settings.json"
    if [ -f "$global" ]; then
        echo "Global MCPs:" && jq -r '.mcpServers // {} | keys[]' "$global" 2>/dev/null
    fi
}

# Git functions
gac() {
    git add --all && git commit -m "$1"
}

gacp() {
    git add --all && git commit -m "$1" && git push
}
