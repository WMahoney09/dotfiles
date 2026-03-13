#!/usr/bin/env bash
# Claude Code SessionEnd hook
# Removes the TTY-keyed context temp file so the tmux widget disappears.

tty_name=$(ps -o tty= -p "$PPID" 2>/dev/null | tr -d ' ') || exit 0
[ -z "$tty_name" ] || [ "$tty_name" = "??" ] && exit 0

rm -f "/tmp/claude-context-${tty_name}.json"
