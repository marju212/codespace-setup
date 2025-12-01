# codespace-setup

Setup scripts for configuring GitHub Codespaces with personal bash settings and Claude Code.

## Quick Start

In any new Codespace, run:

```bash
git clone https://github.com/marju212/codespace-setup ~/codespace-setup
~/codespace-setup/setup.sh
```

Then authenticate Claude Code:

```bash
claude
```

## What It Does

- **Installs Claude Code** - CLI tool via npm
- **Configures bash** - Sources custom aliases from this repo

## Updating

After making changes to this repo, pull updates in your Codespace:

```bash
cd ~/codespace-setup && git pull
```

Alias changes take effect in new terminals. For other changes, re-run `setup.sh`.

## Customization

Add your aliases to `dotfiles/.bash_aliases`.
