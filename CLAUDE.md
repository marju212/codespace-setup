# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Setup scripts for configuring GitHub Codespaces environments with personal bash settings and Claude Code CLI.

## Usage

In a new Codespace:
```bash
git clone https://github.com/marju212/codespace-setup ~/codespace-setup
~/codespace-setup/setup.sh
claude  # authenticate
```

## Structure

- `setup.sh` - Main entry point, runs all setup scripts
- `scripts/install-claude.sh` - Installs Claude Code via npm
- `scripts/setup-bash.sh` - Adds source line to ~/.bashrc
- `dotfiles/.bash_aliases` - Custom aliases (sourced by bashrc)

## Design Principles

- All scripts are idempotent (safe to re-run)
- Bashrc sources aliases from repo path, so `git pull` updates take effect without re-running setup
- Scripts use `set -e` to fail fast on errors
