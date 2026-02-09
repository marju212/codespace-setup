# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal dotfiles repository, automatically applied by GitHub Codespaces on creation.

## How It Works

GitHub Codespaces clones this repo and runs `install.sh` automatically when a Codespace is created (configured in GitHub Settings > Codespaces > Dotfiles).

## Structure

- `install.sh` - Entry point, run automatically by Codespaces. Symlinks dotfiles and installs tools.
- `.bash_aliases` - Custom shell aliases and functions (symlinked to `~/.bash_aliases`)

## Design Principles

- `install.sh` is idempotent (safe to re-run)
- Dotfiles are symlinked, so `git pull` in the dotfiles repo updates them without re-running install
- Scripts use `set -e` to fail fast on errors
- New dotfiles just need to be added to the repo root and the `install.sh` loop
