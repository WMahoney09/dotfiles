# Dotfiles

Personal dev environment configuration files — shell, terminal, editor, and prompt.

## What's included

| Tool | Config location | Description |
|---|---|---|
| Zsh | `.zshrc`, `.zsh_plugins.txt` | Shell config with Antidote plugin manager |
| Ghostty | `ghostty/config` | Terminal emulator (Dracula theme, Fira Code, vim-style splits) |
| NeoVim | `nvim/` | AstroNvim user config with Mason auto-installed LSPs |
| Starship | `starship.toml` | Cross-shell prompt with git integration |

## Prerequisites

- macOS + [Homebrew](https://brew.sh/)
- [asdf](https://asdf-vm.com/) (for runtime version management)

## Quick start

```bash
# Clone
git clone <repo-url> ~/agentic/tooling/dotfiles
cd ~/agentic/tooling/dotfiles

# Install packages (macOS)
brew bundle

# Create symlinks
./setup.sh
```

## Linux notes

Homebrew is macOS-specific. On Linux, install the equivalent packages manually:

```bash
# Example (Ubuntu/Debian)
sudo apt install neovim fzf
# Install starship, antidote, zoxide, and ghostty per their docs
```

Then run `./setup.sh` — the symlink setup is platform-independent.

## Directory structure

```
dotfiles/
  .zshrc                 # Shell config (symlinked to ~/.zshrc)
  .zsh_plugins.txt       # Antidote plugin list (symlinked to ~/.zsh_plugins.txt)
  ghostty/config         # Ghostty terminal config (symlinked to ~/.config/ghostty)
  nvim/                  # AstroNvim user config (symlinked to ~/.config/nvim)
  starship.toml          # Starship prompt config (symlinked to ~/.config/starship.toml)
  Brewfile               # Homebrew package list
  setup.sh               # Idempotent symlink script
```

## How setup.sh works

`setup.sh` creates symlinks from standard config locations into this repo. If a file or directory already exists at a target location, it's backed up to `~/.dotfiles-backup/<timestamp>/` before being replaced. Running the script multiple times is safe — it skips symlinks that already point correctly.
