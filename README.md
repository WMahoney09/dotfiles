# Dotfiles

Personal dev environment configuration files — shell, terminal, editor, prompt, and AI tooling.

## What's included

| Tool | Config location | Description |
|---|---|---|
| Zsh | `.zshrc`, `.zsh_plugins.txt` | Shell config with Antidote plugin manager |
| Ghostty | `ghostty/config` | Terminal emulator (Dracula theme, Fira Code, vim-style splits) |
| NeoVim | `nvim/` | AstroNvim user config with Mason auto-installed LSPs |
| Starship | `starship.toml` | Cross-shell prompt with git integration |
| tmux | `tmux/` | Terminal multiplexer with TPM plugin manager |
| Claude Code | `claude-code/` | AI coding assistant settings, global instructions, and MCP servers |

## Getting started

If you're a colleague picking this up, **fork the repo** first — then clone your fork. This gives you your own copy to customize while still being able to pull updates from upstream.

```bash
# Fork via GitHub, then:
git clone git@github.com:<your-username>/dotfiles.git ~/agentic/tooling/dotfiles
cd ~/agentic/tooling/dotfiles

# Track upstream for future updates
git remote add upstream git@github.com:WMahoney09/dotfiles.git

# Install packages (macOS — optional, see below)
brew bundle

# Create symlinks, secrets template, and MCP servers
./setup.sh
```

After running `setup.sh`, edit `.secrets` and fill in your own token values (see `.secrets.example` for what's needed).

To pull future updates from upstream:

```bash
git fetch upstream
git merge upstream/main
```

## Platform notes

The symlink setup (`setup.sh`) is platform-independent. Package installation varies:

- **macOS** — Install [Homebrew](https://brew.sh/), then run `brew bundle` to install everything from the `Brewfile`.
- **Linux** — Install the equivalent packages manually:
  ```bash
  # Example (Ubuntu/Debian)
  sudo apt install neovim fzf
  # Install starship, antidote, zoxide, and ghostty per their docs
  ```

## Directory structure

```
dotfiles/
  .zshrc                 # Shell config (symlinked to ~/.zshrc)
  .zsh_plugins.txt       # Antidote plugin list (symlinked to ~/.zsh_plugins.txt)
  .secrets               # Token env vars — gitignored (symlinked to ~/.secrets)
  .secrets.example       # Template showing required keys
  ghostty/config         # Ghostty terminal config (symlinked to ~/.config/ghostty)
  nvim/                  # AstroNvim user config (symlinked to ~/.config/nvim)
  starship.toml          # Starship prompt config (symlinked to ~/.config/starship.toml)
  tmux/                  # tmux config and themes (symlinked to ~/.tmux.conf)
  claude-code/           # Claude Code config (symlinked to ~/.config/claude-code)
  Brewfile               # Homebrew package list
  setup.sh               # Idempotent symlink script
```

## How setup.sh works

`setup.sh` creates symlinks from standard config locations into this repo. If a file or directory already exists at a target location, it's backed up to `~/.dotfiles-backup/<timestamp>/` before being replaced. Running the script multiple times is safe — it skips symlinks that already point correctly.
