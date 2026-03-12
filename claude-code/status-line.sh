#!/usr/bin/env bash
# Claude Code status line script
# Reads JSON from stdin, writes context data to a TTY-keyed temp file,
# and prints a status string to stdout for Claude Code's own status bar.

set -euo pipefail

input=$(cat)

used=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')

# Nothing to do if we don't have context data yet
[ -z "$used" ] && exit 0

remaining=$(printf '%s' "$input" | jq -r '.context_window.remaining_percentage // empty')

# Derive TTY-keyed temp file path
# The script runs as a child process without a direct TTY, so resolve
# the controlling terminal from the parent process (Claude Code).
tty_name=$(ps -o tty= -p "$PPID" 2>/dev/null | tr -d ' ') || tty_name=""
[ -z "$tty_name" ] || [ "$tty_name" = "??" ] && tty_name="unknown"
tmp_file="/tmp/claude-context-${tty_name}.json"

# Write context data with timestamp for staleness detection
printf '{"used":%s,"remaining":%s,"timestamp":%s}\n' \
  "$used" "${remaining:-0}" "$(date +%s)" > "$tmp_file"

# Print status for Claude Code's own status bar
printf 'ctx %s%%' "$used"
