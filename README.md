# dotfiles

Personal dotfiles for GitHub Codespaces. Automatically applied when creating any new Codespace.

## Setup (one-time)

1. Go to [GitHub Settings > Codespaces](https://github.com/settings/codespaces)
2. Under **Dotfiles**, check "Automatically install dotfiles"
3. Select this repository (`marju212/codespace-setup`)

That's it. Every new Codespace will automatically run `install.sh` and configure your environment.

## What It Does

- **Symlinks `.bash_aliases`** to `~/` (git shortcuts, navigation aliases, Claude CLI alias)
- **Installs Claude Code** CLI via npm

## Adding Dotfiles

Add new dotfiles (e.g., `.gitconfig`, `.vimrc`) to the repo root and add them to the `install.sh` loop:

```bash
for file in .bash_aliases .gitconfig .vimrc; do
```

## Manual Run

If you need to re-run in an existing Codespace:

```bash
~/.dotfiles/install.sh
```

## Customization

Edit `.bash_aliases` to add or change aliases. Changes take effect in new Codespaces automatically, or run `source ~/.bash_aliases` in existing ones.
