#!/usr/bin/env bash
set -euo pipefail

# ─── Dotfiles Setup ──────────────────────────────────────────────────────────
# Idempotent symlink script. Creates symlinks from standard config locations
# into this dotfiles directory. Backs up any existing files/directories before
# replacing them.

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# ─── Helpers ──────────────────────────────────────────────────────────────────

backup_and_link() {
  local source="$1"
  local target="$2"

  # Already correctly linked — nothing to do
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo "  [ok]  $target → $source"
    return
  fi

  # Existing symlink pointing elsewhere
  if [ -L "$target" ]; then
    echo "  [warn] $target is a symlink to $(readlink "$target"), replacing"
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/$(basename "$target").symlink"
  # Existing file or directory
  elif [ -e "$target" ]; then
    echo "  [backup] $target → $BACKUP_DIR/"
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
  fi

  # Ensure parent directory exists
  mkdir -p "$(dirname "$target")"

  ln -s "$source" "$target"
  echo "  [link] $target → $source"
}

# ─── Symlinks ─────────────────────────────────────────────────────────────────

echo "Dotfiles: $DOTFILES_DIR"
echo ""

echo "Setting up symlinks..."
backup_and_link "$DOTFILES_DIR/.zshrc"            "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/.zsh_plugins.txt"   "$HOME/.zsh_plugins.txt"
backup_and_link "$DOTFILES_DIR/ghostty"            "$HOME/.config/ghostty"
backup_and_link "$DOTFILES_DIR/nvim"               "$HOME/.config/nvim"
backup_and_link "$DOTFILES_DIR/starship.toml"      "$HOME/.config/starship.toml"
backup_and_link "$DOTFILES_DIR/tmux/tmux.conf"     "$HOME/.tmux.conf"

echo ""

# ─── TPM (Tmux Plugin Manager) ──────────────────────────────────────────────
echo "Setting up TPM..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  echo "  [install] TPM cloned — press prefix + I inside tmux to install plugins"
else
  echo "  [ok]  TPM already installed"
fi

echo ""
if [ -d "$BACKUP_DIR" ]; then
  echo "Backups saved to: $BACKUP_DIR"
else
  echo "No backups needed — all symlinks were already correct."
fi
echo "Done."
