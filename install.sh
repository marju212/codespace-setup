#!/bin/bash
# Dotfiles install script - auto-run by GitHub Codespaces
# GitHub clones this repo and runs install.sh when a Codespace is created.

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN="$HOME/.local/bin"

case ":$PATH:" in
    *":$LOCAL_BIN:"*) ;;
    *) export PATH="$LOCAL_BIN:$PATH" ;;
esac

echo "=========================================="
echo "  Codespace Dotfiles Setup"
echo "=========================================="
echo ""

# Remove problematic yarn source and install dependencies
echo "==> Installing system dependencies..."
sudo rm /etc/apt/sources.list.d/yarn.list 2>/dev/null || true
sudo apt update && sudo apt install tmux -y

# Ensure jq is available (needed for mcp-merge)
if ! command -v jq &> /dev/null; then
    echo "==> Installing jq..."
    sudo apt-get update -qq && sudo apt-get install -y -qq jq > /dev/null 2>&1
    echo "    jq installed"
fi

# Symlink dotfiles
echo "==> Linking dotfiles..."
for file in .bash_aliases; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
        echo "    Linked $file -> $HOME/$file"
    fi
done

# Link Claude and Codex instruction files in workspace repositories
echo ""
echo "==> Linking Claude/Codex instruction files..."
if [ -d /workspaces ]; then
    for repo_dir in /workspaces/*; do
        [ -d "$repo_dir" ] || continue

        claude_file="$repo_dir/CLAUDE.md"
        agents_file="$repo_dir/AGENTS.md"

        if [ -e "$claude_file" ] && [ ! -e "$agents_file" ] && [ ! -L "$agents_file" ]; then
            ln -s CLAUDE.md "$agents_file"
            echo "    Linked $agents_file -> CLAUDE.md"
        elif [ -e "$agents_file" ] && [ ! -e "$claude_file" ] && [ ! -L "$claude_file" ]; then
            ln -s AGENTS.md "$claude_file"
            echo "    Linked $claude_file -> AGENTS.md"
        fi
    done
else
    echo "    Skipping instruction links (/workspaces not found)"
fi

# Install default VS Code extensions
echo ""
echo "==> Installing default VS Code extensions..."
EXTENSIONS=(
    eamodio.gitlens
    esbenp.prettier-vscode
    dbaeumer.vscode-eslint
    ms-vscode.live-server
    yzhang.markdown-all-in-one
    timonwong.shellcheck
    ms-python.python
)
for ext in "${EXTENSIONS[@]}"; do
    code --install-extension "$ext" --force 2>/dev/null && echo "    Installed $ext" || true
done

# Install Node.js if not available
if ! command -v npm &> /dev/null; then
    echo ""
    echo "==> Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - > /dev/null 2>&1
    sudo apt-get install -y -qq nodejs > /dev/null 2>&1
    echo "    Node.js $(node --version) installed"
fi

# Install Claude Code (native installer)
echo ""
echo "==> Checking Claude Code installation..."
# Remove legacy npm installation if present
if npm list -g @anthropic-ai/claude-code &> /dev/null; then
    echo "    Removing npm-based Claude Code..."
    sudo npm uninstall -g @anthropic-ai/claude-code 2>/dev/null || npm uninstall -g @anthropic-ai/claude-code 2>/dev/null || true
    echo "    npm version removed"
fi
if [ -x "$HOME/.local/bin/claude" ]; then
    echo "    Claude Code already installed: $($HOME/.local/bin/claude --version 2>/dev/null || echo 'version unknown')"
else
    echo "    Installing Claude Code via native installer..."
    curl -fsSL https://claude.ai/install.sh | bash
    echo "    Claude Code installed successfully"
fi

# Install Codex CLI (native installer)
echo ""
echo "==> Checking Codex CLI installation..."
if command -v codex &> /dev/null; then
    echo "    Codex CLI already installed: $(codex --version 2>/dev/null || echo 'version unknown')"
else
    echo "    Installing Codex CLI via native installer..."
    curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
    echo "    Codex CLI installed successfully"
fi

# Configure global MCP servers
echo ""
echo "==> Configuring global MCP servers..."
if command -v claude &> /dev/null; then
    claude mcp add --scope global memory -- npx -y @modelcontextprotocol/server-memory 2>/dev/null && echo "    Added memory MCP" || true
    claude mcp add --scope global filesystem -- npx -y @modelcontextprotocol/server-filesystem /workspaces 2>/dev/null && echo "    Added filesystem MCP" || true
    claude mcp add --scope global github -- npx -y @modelcontextprotocol/server-github 2>/dev/null && echo "    Added github MCP" || true
else
    echo "    Skipping MCP setup (Claude Code not installed)"
fi

echo ""
echo "=========================================="
echo "  Setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  Run 'claude' to authenticate (required once per Codespace)"
echo "  Run 'codex' to authenticate (required once per Codespace)"
