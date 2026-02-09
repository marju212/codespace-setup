# dotfiles

Personal dotfiles for GitHub Codespaces. Automatically applied when creating any new Codespace.

## Setup (one-time)

1. Go to [GitHub Settings > Codespaces](https://github.com/settings/codespaces)
2. Under **Dotfiles**, check "Automatically install dotfiles"
3. Select this repository (`marju212/codespace-setup`)

That's it. Every new Codespace will automatically run `install.sh` and configure your environment.

## What It Does

- **Symlinks `.bash_aliases`** to `~/` (git shortcuts, navigation aliases, Claude CLI alias)
- **Installs default VS Code extensions** (GitLens, Prettier, ESLint, Live Server, Markdown, ShellCheck, Python)
- **Installs Claude Code** CLI via npm

## Project-Specific Environments

This repo provides your **global** defaults. For project-specific environments, add a `devcontainer.json` to that repo. Both layers work together — the devcontainer sets up the tools, and your dotfiles apply on top.

### Using a Template

Copy a template into your project repo:

```bash
mkdir -p .devcontainer
cp ~/.dotfiles/templates/<template>.devcontainer.json .devcontainer/devcontainer.json
```

### Available Templates

| Template | Image | Use case |
|----------|-------|----------|
| `base` | `universal:2` | Multi-language (Node + Python + common CLIs) |
| `python` | `python:3.12` | Python projects (+ pylint, black) |
| `node` | `javascript-node:22` | Node/JS projects (+ Tailwind CSS) |

### How the Layers Work

```
Global (this repo)              Per-repo (.devcontainer/devcontainer.json)
├── Shell aliases               ├── Docker image / runtime
├── Default VS Code extensions  ├── Project-specific extensions
└── Claude Code CLI             ├── Dev tools (features)
                                └── postCreateCommand (install deps)
```

Global defaults apply to **all** Codespaces. Per-repo config only needs to add what's **specific** to that project — no need to repeat common extensions.

### Example: Adding a devcontainer to a Python project

Create `.devcontainer/devcontainer.json` in your project repo:

```json
{
  "name": "My Python App",
  "image": "mcr.microsoft.com/devcontainers/python:3.12",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {}
  },
  "customizations": {
    "vscode": {
      "extensions": ["ms-python.pylint"]
    }
  },
  "postCreateCommand": "pip install -r requirements.txt"
}
```

## Adding Dotfiles

Add new dotfiles (e.g., `.gitconfig`, `.vimrc`) to the repo root and add them to the `install.sh` loop:

```bash
for file in .bash_aliases .gitconfig .vimrc; do
```

## Updating Existing Codespaces

New Codespaces get the latest automatically. For running Codespaces:

```bash
dotup
```

This alias pulls the latest dotfiles and reloads your aliases.

## Customization

Edit `.bash_aliases` to add or change aliases. Changes take effect in new Codespaces automatically, or run `source ~/.bash_aliases` in existing ones.
