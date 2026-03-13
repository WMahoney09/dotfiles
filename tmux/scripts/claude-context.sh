#!/usr/bin/env bash
# tmux status bar widget: Claude Code context window utilization
# Renders a color-coded block bar when the active pane runs Claude Code.
# Returns empty string otherwise.

set -euo pipefail

# TTY is passed as $1 from tmux config (#{pane_tty} expanded per-session)
pane_tty="${1:-}"
[ -z "$pane_tty" ] && exit 0
tty_key=$(echo "$pane_tty" | sed 's|/dev/||; s|/|-|g')
tmp_file="/tmp/claude-context-${tty_key}.json"

# No file means no Claude session in this pane
[ -f "$tmp_file" ] || exit 0

# Read context data
data=$(cat "$tmp_file" 2>/dev/null) || exit 0
used=$(echo "$data" | jq -r '.used // empty') || exit 0

# Validate we got data
[ -z "$used" ] && exit 0

# Resolve theme colors from tmux variables
color_green=$(tmux show -gqv @thm_green 2>/dev/null)
color_yellow=$(tmux show -gqv @thm_yellow 2>/dev/null)
color_red=$(tmux show -gqv @thm_red 2>/dev/null)
color_overlay=$(tmux show -gqv @thm_overlay_0 2>/dev/null)

# Pick color based on threshold
if [ "$used" -ge 80 ]; then
  color="${color_red:-red}"
elif [ "$used" -ge 50 ]; then
  color="${color_yellow:-yellow}"
else
  color="${color_green:-green}"
fi

# Build 10-segment block bar
filled=$((used / 10))
empty=$((10 - filled))
bar=""
for ((i = 0; i < filled; i++)); do bar+="▓"; done
for ((i = 0; i < empty; i++)); do bar+="░"; done

# Render with tmux style tags
printf '#[fg=%s]ctx %s %d%%#[default] ' "$color" "$bar" "$used"
