#!/bin/bash
# Main setup script for Codespace environment
# Run this after cloning the repo to ~/codespace-setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "  Codespace Setup"
echo "=========================================="
echo ""

# Run setup scripts
"$SCRIPT_DIR/scripts/setup-bash.sh"
echo ""
"$SCRIPT_DIR/scripts/install-claude.sh"

echo ""
echo "=========================================="
echo "  Setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Run 'source ~/.bashrc' to load aliases"
echo "  2. Run 'claude' to authenticate Claude Code"
echo ""
