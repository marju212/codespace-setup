#!/bin/bash
# Dotfiles install script - auto-run by GitHub Codespaces
# GitHub clones this repo and runs install.sh when a Codespace is created.

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "  Codespace Dotfiles Setup"
echo "=========================================="
echo ""

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

# Configure Claude Code MCP servers
echo ""
echo "==> Configuring Claude Code MCP servers..."
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
    cp "$DOTFILES_DIR/claude-settings.json" "$CLAUDE_DIR/settings.json"
    echo "    Installed default MCP config to $CLAUDE_DIR/settings.json"
else
    echo "    Claude settings already exist, skipping (edit ~/.claude/settings.json to update)"
fi

# Install Node.js if not available
if ! command -v npm &> /dev/null; then
    echo ""
    echo "==> Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - > /dev/null 2>&1
    sudo apt-get install -y -qq nodejs > /dev/null 2>&1
    echo "    Node.js $(node --version) installed"
fi

# Install Claude Code
echo ""
echo "==> Checking Claude Code installation..."
if command -v claude &> /dev/null; then
    echo "    Claude Code already installed: $(claude --version 2>/dev/null || echo 'version unknown')"
else
    echo "    Installing Claude Code..."
    sudo npm install -g @anthropic-ai/claude-code
    echo "    Claude Code installed successfully"
fi

echo ""
echo "=========================================="
echo "  Setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  Run 'claude' to authenticate (required once per Codespace)"
