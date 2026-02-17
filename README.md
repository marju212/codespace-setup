# dotfiles

Personal dotfiles for GitHub Codespaces. Automatically applied when creating any new Codespace.

## Setup (one-time)

1. Go to [GitHub Settings > Codespaces](https://github.com/settings/codespaces)
2. Under **Dotfiles**, check "Automatically install dotfiles"
3. Select this repository (`marju212/codespace-setup`)

That's it. Every new Codespace will automatically run `install.sh` and configure your environment.

## Applying to Existing Codespaces

Dotfiles are only auto-applied when a Codespace is **created**. For Codespaces that already exist:

```bash
git clone https://github.com/marju212/codespace-setup ~/.dotfiles
~/.dotfiles/install.sh
```

After that, use `dotup` to pull future updates (see [Updating Existing Codespaces](#updating-existing-codespaces)).

Alternatively, you can rebuild the Codespace to trigger a fresh dotfiles install:
- Press `F1` > **Codespaces: Rebuild Container**

## What It Does

- **Installs `jq`** (needed for MCP merge functions)
- **Symlinks `.bash_aliases`** to `~/` (git shortcuts, navigation aliases, MCP tools, Claude CLI alias)
- **Installs default VS Code extensions** (GitLens, Prettier, ESLint, Live Server, Markdown, ShellCheck, Python)
- **Configures Claude Code MCP servers** (memory, filesystem, GitHub)
- **Installs Claude Code** CLI via native installer (auto-removes legacy npm version if present)

## Available Aliases

### Git

| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `ga` / `gaa` | `git add` / `git add --all` |
| `gc` / `gcm` | `git commit` / `git commit -m` |
| `gp` / `gpl` | `git push` / `git pull` |
| `gco` / `gcb` | `git checkout` / `git checkout -b` |
| `gd` / `gds` | `git diff` / `git diff --staged` |
| `gl` / `glog` | `git log --oneline` / `git log --graph` |
| `gac "msg"` | `git add --all && git commit -m "msg"` |
| `gacp "msg"` | `git add --all && git commit -m "msg" && git push` |

### Tools

| Alias | What it does |
|-------|-------------|
| `cl` | Run Claude Code with `--dangerously-skip-permissions` |
| `dotup` | Pull latest dotfiles and reload aliases |
| `use-template <name>` | Apply a devcontainer template to current project |
| `mcp-merge [file]` | Merge MCP servers into project `.claude/settings.json` |
| `mcp-list` | Show all active MCPs (project + global) |

## Project-Specific Environments

This repo provides your **global** defaults. For project-specific environments, add a `devcontainer.json` to that repo. Both layers work together — the devcontainer sets up the tools, and your dotfiles apply on top.

### Using a Template

The easiest way is the `use-template` alias:

```bash
use-template juce-platformio
```

Run `use-template` without arguments to list all available templates. Then rebuild the Codespace (`F1` > **Codespaces: Rebuild Container**).

### Available Templates

| Template | Image | Use case |
|----------|-------|----------|
| `base` | `universal:2` | Multi-language (Node + Python + common CLIs) |
| `python` | `python:3.12` | Python projects (+ pylint, black) |
| `node` | `javascript-node:22` | Node/JS projects (+ Tailwind CSS) |
| `juce-platformio` | `cpp:ubuntu-22.04` + Dockerfile | C++ JUCE audio/GUI + PlatformIO (RP2040-Zero, Teensy 4.1) |

### How the Layers Work

```
Global (this repo)              Per-repo (.devcontainer/devcontainer.json)
├── Shell aliases               ├── Docker image / runtime
├── Default VS Code extensions  ├── Project-specific extensions
├── Global MCP servers          ├── Project-specific MCP servers
└── Claude Code CLI             ├── Dev tools (features)
                                └── postCreateCommand (install deps)
```

Global defaults apply to **all** Codespaces. Per-repo config only needs to add what's **specific** to that project — no need to repeat common extensions or MCPs.

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

## Rebuilding a Codespace

After adding or changing a `devcontainer.json` (or its Dockerfile), you need to rebuild for changes to take effect.

1. Press `F1` (or `Ctrl+Shift+P`) to open the Command Palette
2. Type **rebuild** and select **Codespaces: Rebuild Container**

If Dockerfile changes aren't picked up, use **Codespaces: Full Rebuild Container** instead (rebuilds without cache).

Your files and git state are preserved — only the container environment is rebuilt.

## MCP Servers

Claude Code MCP servers are configured at two levels:

- **Global** (`~/.claude/settings.json`) — applies to all projects, installed by `install.sh`
- **Project** (`.claude/settings.json`) — per-repo, merged via `mcp-merge`

### Default Global MCPs

| Server | What it does |
|--------|-------------|
| **memory** | Persistent knowledge graph — Claude remembers context across conversations |
| **filesystem** | Read/write access to `/workspaces` — Claude can browse and edit project files |
| **github** | GitHub API access — Claude can manage issues, PRs, and repos |

### Template MCPs

Some templates include project-specific MCP servers, auto-merged on container creation:

| Template | MCP | What it does |
|----------|-----|-------------|
| `juce-platformio` | **juce-docs** | JUCE Framework class documentation — search classes, get API docs from Stanford CCRMA |

### Managing MCPs

**List active MCPs:**

```bash
mcp-list
```

**Merge a template's MCPs into your project** (safe — won't overwrite existing MCPs):

```bash
mcp-merge .devcontainer/claude-settings.json
```

Without arguments, `mcp-merge` defaults to `.devcontainer/claude-settings.json`.

**Edit global MCPs:**

Edit `claude-settings.json` in this repo. Changes apply to new Codespaces automatically. For existing Codespaces, delete `~/.claude/settings.json` and re-run `~/.dotfiles/install.sh`.

### GitHub MCP Setup

The GitHub MCP needs a personal access token:

1. Go to [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
2. Create a token with `repo` scope
3. Edit `~/.claude/settings.json` and set the token:

```json
"GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
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
