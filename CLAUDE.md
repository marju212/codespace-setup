# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Setup scripts for configuring GitHub Codespaces environments with personal bash settings and Claude Code CLI. The repo is designed to be cloned into `~/codespace-setup` and provides a one-command setup experience for new Codespaces.

## Quick Start

In a new Codespace:
```bash
git clone https://github.com/marju212/codespace-setup ~/codespace-setup
~/codespace-setup/setup.sh
source ~/.bashrc  # load aliases immediately
claude            # authenticate Claude Code
```

## Repository Structure

```
codespace-setup/
├── setup.sh                    # Main entry point - orchestrates all setup
├── scripts/
│   ├── install-claude.sh       # Installs Claude Code CLI via npm
│   └── setup-bash.sh           # Configures ~/.bashrc to source aliases
├── dotfiles/
│   └── .bash_aliases           # Custom shell aliases and functions
├── README.md                   # User-facing documentation
└── CLAUDE.md                   # AI assistant guidance (this file)
```

### File Details

| File | Purpose |
|------|---------|
| `setup.sh` | Main orchestrator that runs setup-bash.sh then install-claude.sh with formatted output |
| `scripts/install-claude.sh` | Checks if `claude` command exists; if not, installs `@anthropic-ai/claude-code` globally via npm |
| `scripts/setup-bash.sh` | Appends source line to ~/.bashrc if not already present (checks for "codespace-setup" string) |
| `dotfiles/.bash_aliases` | Contains navigation aliases (`..`, `ll`), git shortcuts (`gs`, `gp`, `gco`), and helper functions (`gac`, `gacp`) |

## Design Principles

1. **Idempotent scripts** - All scripts are safe to re-run multiple times without side effects
2. **Live updates** - Bashrc sources aliases directly from repo path, so `git pull` updates take effect in new terminals without re-running setup
3. **Fail-fast** - All scripts use `set -e` to exit immediately on any error
4. **Minimal dependencies** - Only requires npm (pre-installed in Codespaces)

## Development Workflow

### Adding New Aliases
Edit `dotfiles/.bash_aliases` directly. Changes take effect in new terminal sessions after `git pull`.

### Adding New Setup Steps
1. Create a new script in `scripts/` with `#!/bin/bash` and `set -e`
2. Make it executable: `chmod +x scripts/your-script.sh`
3. Add a call to it in `setup.sh` following the existing pattern

### Testing Changes
```bash
# Test individual scripts
./scripts/install-claude.sh
./scripts/setup-bash.sh

# Test full setup (safe to re-run)
./setup.sh
```

## Key Conventions

### Script Patterns
- Start with `#!/bin/bash` and `set -e`
- Use `echo "==> Description..."` for main action headers
- Use `echo "    Details..."` for indented sub-messages
- Check if already configured before making changes (idempotency)

### Git Aliases Available
| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gc` | `git commit` |
| `gcm` | `git commit -m` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gl` | `git log --oneline -20` |
| `gac "msg"` | `git add --all && git commit -m "msg"` |
| `gacp "msg"` | `git add --all && git commit -m "msg" && git push` |

## Troubleshooting

- **Aliases not working**: Run `source ~/.bashrc` or open a new terminal
- **Claude not found after install**: Ensure npm global bin is in PATH
- **Setup already done message**: Scripts are idempotent; this is expected on re-run
