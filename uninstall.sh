#!/usr/bin/env bash
set -euo pipefail

# ─── Dotfiles Uninstall ────────────────────────────────────────────────────
# Reverses everything setup.sh did. Removes symlinks that point into this
# repo, restores backups if available, removes MCP servers, and cleans up
# TPM. Only touches symlinks that actually belong to this dotfiles repo.

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── Helpers ──────────────────────────────────────────────────────────────────

remove_if_ours() {
  local target="$1"

  if [ -L "$target" ]; then
    local link_dest
    link_dest="$(readlink "$target")"
    case "$link_dest" in
      "$DOTFILES_DIR"*)
        rm "$target"
        echo "  [rm]   $target"
        ;;
      *)
        echo "  [skip] $target → $link_dest (not ours)"
        ;;
    esac
  elif [ -e "$target" ]; then
    echo "  [skip] $target exists but is not a symlink"
  else
    echo "  [skip] $target does not exist"
  fi
}

# ─── Remove symlinks ────────────────────────────────────────────────────────

echo "Removing symlinks..."
remove_if_ours "$HOME/.zshrc"
remove_if_ours "$HOME/.zsh_plugins.txt"
remove_if_ours "$HOME/.secrets"
remove_if_ours "$HOME/.config/ghostty"
remove_if_ours "$HOME/.config/nvim"
remove_if_ours "$HOME/.config/starship.toml"
remove_if_ours "$HOME/.tmux.conf"
remove_if_ours "$HOME/.tmux.conf.d/themes"
remove_if_ours "$HOME/.config/claude-code"
remove_if_ours "$HOME/.claude/settings.json"
remove_if_ours "$HOME/.claude/CLAUDE.md"

# ─── Restore backups ────────────────────────────────────────────────────────

echo ""
echo "Checking for backups..."
if [ -d "$HOME/.dotfiles-backup" ]; then
  LATEST_BACKUP=$(ls -dt "$HOME/.dotfiles-backup"/*/ 2>/dev/null | head -1)
  if [ -n "$LATEST_BACKUP" ]; then
    echo "  Found backup: $LATEST_BACKUP"
    echo "  To restore, copy files from that directory to their original locations."
  else
    echo "  [skip] Backup directory exists but is empty"
  fi
else
  echo "  [skip] No backups found"
fi

# ─── Remove MCP servers ─────────────────────────────────────────────────────

echo ""
echo "Removing MCP servers..."
if command -v claude >/dev/null 2>&1; then
  claude mcp remove context7 2>/dev/null && echo "  [rm]   context7" || echo "  [skip] context7"
  claude mcp remove render 2>/dev/null && echo "  [rm]   render" || echo "  [skip] render"
  claude mcp remove vercel 2>/dev/null && echo "  [rm]   vercel" || echo "  [skip] vercel"
  claude mcp remove figma 2>/dev/null && echo "  [rm]   figma" || echo "  [skip] figma"
else
  echo "  [skip] claude CLI not found"
fi

# ─── Remove TPM ──────────────────────────────────────────────────────────────

echo ""
echo "Removing TPM..."
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  rm -rf "$HOME/.tmux/plugins/tpm"
  echo "  [rm]   ~/.tmux/plugins/tpm"
else
  echo "  [skip] TPM not installed"
fi

# ─── Homebrew cleanup ────────────────────────────────────────────────────────

echo ""
if command -v brew >/dev/null 2>&1; then
  echo "To uninstall Homebrew packages from the Brewfile:"
  echo "  brew bundle cleanup --file=$DOTFILES_DIR/Brewfile --force"
  echo "  (not run automatically — may remove packages you use elsewhere)"
else
  echo "Homebrew not installed, skipping."
fi

echo ""
echo "Done. You can now safely delete the repo:"
echo "  rm -rf $DOTFILES_DIR"
