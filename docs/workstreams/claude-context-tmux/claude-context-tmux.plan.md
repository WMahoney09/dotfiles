# Claude Context Window in tmux Status Line

## Overview

Display the active Claude Code session's context window utilization in the tmux status bar. A color-coded block bar with percentage renders when the active pane is running Claude Code; nothing renders otherwise.

The architecture is a two-stage bridge: Claude Code's status line script writes context data to a temp file keyed by TTY, and a tmux status script reads from that file to render the widget.

## Notes

- **Out of scope:** Multi-agent monitoring, orchestration, Claude Code hooks. The temp file bridge built here is the foundation for those future features.
- **Not tracked:** `~/.claude/settings.json` is user-local config, not part of this repo. The plan documents the required entry but doesn't manage it.
- **Display format:** `ctx ▓▓▓▓▓▓░░░░ 62%` — block bar with label and percentage, color shifts at thresholds (green → yellow → red).
- **Graceful degradation:** When the active pane isn't running Claude Code, the widget returns empty string. No visual noise.

## Progress

- [x] Phase 1: Claude Code status line script
- [x] Phase 2: tmux status reader script
- [ ] Phase 3: tmux config integration
- [ ] Phase 4: setup.sh and installation

---

## Phase 1: Claude Code status line script

Write the script that Claude Code invokes after each response, bridging context data to the filesystem.

### Step 1.1: Create `claude-code/status-line.sh`

#### Task 1.1.1: Script skeleton
Create `claude-code/status-line.sh` as a bash script. It reads JSON from stdin, extracts `context_window.used_percentage` and `context_window.remaining_percentage`, and writes them to a temp file.

#### Task 1.1.2: TTY-keyed file path
Derive the temp file path from the current TTY (`tty` command), sanitizing slashes to produce a filename like `/tmp/claude-context-ttys004.json`. This ensures each pane gets its own file.

#### Task 1.1.3: Write context data
Write a small JSON payload to the temp file: `{"used": <pct>, "remaining": <pct>, "timestamp": <epoch>}`. The timestamp allows the tmux reader to detect stale data.

#### Task 1.1.4: Pass-through stdout
The script must also print a status string to stdout for Claude Code's own status bar rendering. This can be a simple context percentage or bar — it's the in-terminal display, separate from the tmux widget.

### Critical files
- **Create:** `claude-code/status-line.sh`

### Gotchas
- `jq` dependency — need to confirm it's available or use a lightweight alternative (Python one-liner, or pure bash with simple pattern matching if the JSON structure is stable).
- The script runs on every response — it must be fast (no network calls, minimal disk I/O).

---

## Phase 2: tmux status reader script

Write the script that tmux calls on its status refresh interval to render the widget.

### Step 2.1: Create `tmux/scripts/claude-context.sh`

#### Task 2.1.1: Resolve active pane TTY
Use `tmux display-message -p '#{pane_tty}'` to get the active pane's TTY, then derive the matching temp file path.

#### Task 2.1.2: Read and validate context data
Read the temp file. If it doesn't exist or the timestamp is stale (e.g., > 5 minutes old), return empty string — the pane isn't running an active Claude session.

#### Task 2.1.3: Render the block bar
Convert `used` percentage to a 10-segment block bar using `▓` (filled) and `░` (empty). Prepend `ctx ` and append ` NN%`.

#### Task 2.1.4: Color thresholds
Apply tmux style tags based on the percentage:
- Green (`@thm_green`): < 50%
- Yellow (`@thm_yellow`): 50–79%
- Red (`@thm_red`): ≥ 80%

Use tmux's `#{@thm_*}` variables so colors follow the active theme (Catppuccin or Citadel).

### Critical files
- **Create:** `tmux/scripts/claude-context.sh`

### Gotchas
- tmux `#(command)` runs scripts at `status-interval` (default 15s). May want to set this lower (e.g., 5s) for more responsive updates, but not too low to avoid overhead.
- Color application: tmux `#(command)` output supports `#[fg=color]` style tags inline. Need to confirm the Catppuccin theme variable resolution works within `#()` — may need to resolve colors at config load time and pass them as arguments to the script.
- Theme variable resolution: `#{@thm_green}` is a tmux variable, not accessible inside a shell script called by `#()`. The script will need the actual color values passed in, or it reads them via `tmux show -gqv @thm_green` at runtime.

---

## Phase 3: tmux config integration

Wire the widget into the tmux status bar.

### Step 3.1: Update `tmux/tmux.conf`

#### Task 3.1.1: Add widget to status-right
Prepend the Claude context widget to the existing `status-right` chain using `#(~/.tmux/scripts/claude-context.sh)`. Placing it first (leftmost in status-right) keeps it visually prominent.

#### Task 3.1.2: Update theme switcher
Update the theme switcher `bind T` block (line 93) to include the widget in the rebuilt `status-right` string, so it persists across theme switches.

#### Task 3.1.3: Adjust status-right-length
Increase `status-right-length` from 100 to 150 to accommodate the new widget (`ctx ▓▓▓▓▓▓▓▓▓▓ 100%` is ~20 chars plus style tags).

### Critical files
- **Modify:** `tmux/tmux.conf`

---

## Phase 4: setup.sh and installation

Make the new scripts available via symlinks and document the Claude Code configuration.

### Step 4.1: Symlink scripts

#### Task 4.1.1: Add tmux scripts symlink
Add a `backup_and_link` call for `tmux/scripts` → `~/.tmux/scripts` in `setup.sh`.

#### Task 4.1.2: Add claude-code directory symlink
Add a `backup_and_link` call for `claude-code` → `~/.config/claude-code` (or similar) in `setup.sh`. Alternatively, the Claude Code status line config can reference the dotfiles path directly.

### Step 4.2: Document Claude Code configuration

#### Task 4.2.1: Document settings.json entry
The user needs to add this to `~/.claude/settings.json`:
```json
{
  "status_line": {
    "command": "~/.config/claude-code/status-line.sh"
  }
}
```
This step is documentation only — we don't manage `settings.json` in the repo.

### Critical files
- **Modify:** `setup.sh`

### Gotchas
- The `claude-code/` directory is a new top-level directory in the dotfiles repo. Need to update CLAUDE.md to document it.
- `setup.sh` ordering doesn't matter here since there are no dependencies between the new symlinks and existing ones.

---

## Success Criteria

1. When a tmux pane is running Claude Code, the status bar shows a color-coded context bar like `ctx ▓▓▓▓▓░░░░░ 48%`
2. When the active pane is NOT running Claude Code, nothing extra appears in the status bar
3. The widget color shifts from green → yellow → red as context fills
4. Theme switching (prefix + T) preserves the widget
5. The widget updates after each Claude Code response
6. Stale data (no Claude response for 5+ minutes) causes the widget to disappear
7. `setup.sh` creates all necessary symlinks
