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
backup_and_link "$DOTFILES_DIR/tmux/themes"        "$HOME/.tmux.conf.d/themes"
backup_and_link "$DOTFILES_DIR/claude-code"        "$HOME/.config/claude-code"
backup_and_link "$DOTFILES_DIR/claude-code/settings.json" "$HOME/.claude/settings.json"
backup_and_link "$DOTFILES_DIR/claude-code/CLAUDE.md"      "$HOME/.claude/CLAUDE.md"

echo ""

# ─── TPM (Tmux Plugin Manager) ──────────────────────────────────────────────
echo "Setting up TPM..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  echo "  [install] TPM cloned — press prefix + I inside tmux to install plugins"
else
  echo "  [ok]  TPM already installed"
fi

# ─── macOS: Ghostty keybind workaround ───────────────────────────────────────
# Ghostty 1.3.0 regression: Cmd+H fires macOS "Hide" instead of goto_split:left.
# Disable the system menu shortcut so the Ghostty keybind takes precedence.
# See: https://github.com/ghostty-org/ghostty/issues/4590
echo "Setting up macOS workarounds..."
if defaults read com.mitchellh.ghostty NSUserKeyEquivalents 2>/dev/null | grep -q "Hide Ghostty"; then
  echo "  [ok]  Ghostty Cmd+H workaround already applied"
else
  defaults write com.mitchellh.ghostty NSUserKeyEquivalents -dict-add "Hide Ghostty" '\0'
  echo "  [fix] Disabled macOS 'Hide Ghostty' menu shortcut (Cmd+H → goto_split)"
fi

# ─── Secrets template ────────────────────────────────────────────────────────
echo "Checking secrets..."
if [ -f "$HOME/.secrets" ]; then
  echo "  [ok]  ~/.secrets exists"
else
  cp "$DOTFILES_DIR/.secrets.example" "$HOME/.secrets"
  chmod 600 "$HOME/.secrets"
  echo "  [new] Created ~/.secrets from template — fill in your values"
fi

# ─── Claude Code MCP servers ────────────────────────────────────────────────
echo "Setting up MCP servers..."
if command -v claude >/dev/null 2>&1; then
  claude mcp add-json context7 '{"type":"stdio","command":"npx","args":["-y","@upstash/context7-mcp"],"env":{}}' 2>/dev/null
  echo "  [mcp] context7"

  claude mcp add-json github-personal '{"type":"stdio","command":"docker","args":["run","-i","--rm","-e","GITHUB_PERSONAL_ACCESS_TOKEN","ghcr.io/github/github-mcp-server"],"env":{"GITHUB_PERSONAL_ACCESS_TOKEN":"${GITHUB_PERSONAL_ACCESS_TOKEN}"}}' 2>/dev/null
  echo "  [mcp] github-personal"

  claude mcp add-json github-work '{"type":"stdio","command":"docker","args":["run","-i","--rm","-e","GITHUB_PERSONAL_ACCESS_TOKEN","ghcr.io/github/github-mcp-server"],"env":{"GITHUB_PERSONAL_ACCESS_TOKEN":"${GITHUB_PERSONAL_ACCESS_TOKEN_GNAR}"}}' 2>/dev/null
  echo "  [mcp] github-work"

  claude mcp add-json render '{"type":"http","url":"https://mcp.render.com/mcp","headers":{"Authorization":"Bearer ${RENDER_API_TOKEN}"}}' 2>/dev/null
  echo "  [mcp] render"

  claude mcp add-json vercel '{"type":"http","url":"https://mcp.vercel.com"}' 2>/dev/null
  echo "  [mcp] vercel"

  claude mcp add-json figma '{"type":"http","url":"https://mcp.figma.com/mcp"}' 2>/dev/null
  echo "  [mcp] figma"
else
  echo "  [skip] claude CLI not found — install Claude Code first"
fi

echo ""
if [ -d "$BACKUP_DIR" ]; then
  echo "Backups saved to: $BACKUP_DIR"
else
  echo "No backups needed — all symlinks were already correct."
fi
echo "Done."
