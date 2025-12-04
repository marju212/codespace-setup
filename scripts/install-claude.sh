#!/bin/bash
# Install Claude Code CLI

set -e

echo "==> Checking Claude Code installation..."

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "    ERROR: npm is not installed"
    echo "    Please install Node.js and npm first"
    exit 1
fi

if command -v claude &> /dev/null; then
    echo "    Claude Code is already installed: $(claude --version 2>/dev/null || echo 'version unknown')"
else
    echo "    Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    echo "    Claude Code installed successfully"
fi

echo ""
echo "    NOTE: Run 'claude' to authenticate (required once per Codespace)"
