#!/bin/bash
# Dotfiles install script - auto-run by GitHub Codespaces
# GitHub clones this repo and runs install.sh when a Codespace is created.

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "  Codespace Dotfiles Setup"
echo "=========================================="
echo ""

# Symlink dotfiles
echo "==> Linking dotfiles..."
for file in .bash_aliases; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
        echo "    Linked $file -> $HOME/$file"
    fi
done

# Install Claude Code
echo ""
echo "==> Checking Claude Code installation..."
if command -v claude &> /dev/null; then
    echo "    Claude Code already installed: $(claude --version 2>/dev/null || echo 'version unknown')"
else
    echo "    Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    echo "    Claude Code installed successfully"
fi

echo ""
echo "=========================================="
echo "  Setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  Run 'claude' to authenticate (required once per Codespace)"
