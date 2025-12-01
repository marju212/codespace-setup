#!/bin/bash
# Configure bash to source custom aliases

set -e

SETUP_DIR="$HOME/codespace-setup"
ALIASES_FILE="$SETUP_DIR/dotfiles/.bash_aliases"
SOURCE_LINE="# Codespace setup aliases
if [ -f \"$ALIASES_FILE\" ]; then
    source \"$ALIASES_FILE\"
fi"

echo "==> Configuring bash..."

# Check if already configured
if grep -q "codespace-setup" "$HOME/.bashrc" 2>/dev/null; then
    echo "    Bashrc already configured"
else
    echo "" >> "$HOME/.bashrc"
    echo "$SOURCE_LINE" >> "$HOME/.bashrc"
    echo "    Added source line to ~/.bashrc"
fi

echo "    Custom aliases will be loaded from: $ALIASES_FILE"
echo "    Run 'source ~/.bashrc' or open a new terminal to apply"
