#!/bin/bash
# Install Claude Code CLI

set -e

echo "==> Checking Claude Code installation..."

if command -v claude &> /dev/null; then
    echo "    Claude Code is already installed: $(claude --version 2>/dev/null || echo 'version unknown')"
else
    echo "    Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    echo "    Claude Code installed successfully"
fi

echo ""
echo "    NOTE: Run 'claude' to authenticate (required once per Codespace)"
