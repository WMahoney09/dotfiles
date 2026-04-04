# Unified Theme Picker

## Overview

Extend the tmux theme picker (`prefix + T`) to propagate the selected theme across all three layers — Ghostty, tmux, and nvim — from a single interaction. Introduces a shared theme state file (`~/.config/current-theme`) as the source of truth. tmux and Ghostty update immediately at pick time; nvim reads the file on `FocusGained` so each instance updates when you switch into its pane.

## Notes

- **Ghostty reload is manual.** Ghostty has no CLI/IPC API for triggering `reload_config`. After picking a theme, the user must press `cmd+shift+,` (built-in default) to reload Ghostty. The picker will display a reminder. This is a known UX gap — if Ghostty adds programmatic reload in the future, it can be wired in.
- **Theme file stores the raw picker name** (e.g., `grizzly`, `mocha`). Each consumer translates to its own format: tmux sources conf files or sets catppuccin flavor, Ghostty uses the theme name directly, nvim resolves to a colorscheme name.
- **Catppuccin flavor translation.** Paddy themes (citadel, grizzly, ox, terabyte) map 1:1 to nvim colorschemes. Catppuccin flavors (mocha, macchiato, frappe, latte) map to `catppuccin-<name>` in nvim and `Catppuccin <Name>` in Ghostty (Ghostty ships these built-in).
- **PROJECT_THEME still works.** It takes priority over the theme file for per-project overrides. The theme file is the global default.
- **Ghostty config is tracked.** The picker modifies `ghostty/config` in the dotfiles repo (via its symlink). This creates a dirty working tree — same as editing it manually. Commit when desired.
- **Out of scope:** Programmatic Ghostty reload, per-project nvim colorscheme (PROJECT_THEME only affects tmux today), Ghostty Paddy themes that don't exist yet in Ghostty's built-in list.

## Progress

- [x] Phase 1: Theme state file and picker integration
- [x] Phase 2: tmux startup reads theme file
- [ ] Phase 3: nvim FocusGained autocommand

---

## Phase 1: Theme state file and picker integration

Update the tmux theme picker to write the selected theme to a shared state file and update the Ghostty config.

### Step 1.1: Update the picker to write theme state

#### Task 1.1.1: Write selected theme to `~/.config/current-theme`
After the fzf selection, write the theme name (single line, no newline decoration) to `~/.config/current-theme`.

#### Task 1.1.2: Update the `theme = ` line in Ghostty config
Use `sed` to replace the `theme = ...` line in `~/.config/ghostty/config` with the selected theme. For Paddy themes, write the name directly (e.g., `theme = grizzly`). For catppuccin flavors, write the Ghostty built-in name (e.g., `theme = Catppuccin Mocha`).

#### Task 1.1.3: Add Ghostty reload reminder to the display message
Update the `tmux display-message` at the end of the picker to include a hint: `"Theme: $theme (⌘⇧, to reload Ghostty)"`.

**Critical file:** `tmux/tmux.conf` (modify the `bind T` block, lines 85-98)

---

## Phase 2: tmux startup reads theme file

Update the tmux startup theme detection to use the theme file as a fallback when `PROJECT_THEME` is not set.

### Step 2.1: Update the `run-shell` startup block

#### Task 2.1.1: Add theme file fallback
Current priority: `PROJECT_THEME` → citadel. New priority: `PROJECT_THEME` → theme file → citadel. The `run-shell` block reads `~/.config/current-theme` if `PROJECT_THEME` is unset, and applies the theme using the same file-existence routing (custom conf vs catppuccin flavor).

**Critical file:** `tmux/tmux.conf` (modify the `run-shell` block, lines 47-54)

---

## Phase 3: nvim FocusGained autocommand

Add an autocommand to AstroNvim that reads the theme file and applies the colorscheme on focus and startup.

### Step 3.1: Add theme-reading autocommand to astrocore

#### Task 3.1.1: Add `VimEnter` and `FocusGained` autocommands
In `astrocore.lua`, add autocommands that read `~/.config/current-theme`, resolve the colorscheme name, and apply it. On `VimEnter`, always apply. On `FocusGained`, only apply if the theme has changed (compare against `vim.g.colors_name` to avoid unnecessary reloads).

#### Task 3.1.2: Handle Paddy vs catppuccin name resolution
Paddy themes exist as `nvim/colors/<name>.lua` — use `:colorscheme <name>` directly. Catppuccin flavors don't have local files — use `:colorscheme catppuccin-<name>`. The resolution logic: try the raw name with `pcall`, if it fails try `catppuccin-<name>`.

#### Task 3.1.3: Handle missing or empty theme file gracefully
If `~/.config/current-theme` doesn't exist or is empty, fall back to `citadel`. Don't error or produce warnings.

**Critical file:** `nvim/lua/plugins/astrocore.lua` (modify the `opts` block to add `autocmds`)

---

## Gotchas & Risks

- **Ghostty catppuccin naming.** Ghostty's built-in catppuccin themes use title case with a space (e.g., `Catppuccin Mocha`). The picker must map `mocha` → `Catppuccin Mocha` when writing the Ghostty config. Need to verify the exact names Ghostty expects.
- **sed on Ghostty config.** The picker uses `sed` to update the theme line. If the config has multiple `theme =` lines (e.g., a commented-out one like the current state), `sed` must target only the active (uncommented) line.
- **Race between theme file write and nvim read.** Not a real concern — the file is tiny and written atomically, and nvim only reads on focus events (not continuously).
- **catppuccin.nvim must be loaded.** The `catppuccin-<name>` colorschemes only exist if the catppuccin plugin is installed. This is true in the current AstroNvim setup via the community plugin, but worth confirming.

## Success Criteria

- `prefix + T` → pick a Paddy theme → tmux updates instantly, `~/.config/current-theme` is written, Ghostty config is updated
- `cmd+shift+,` after picking → Ghostty reloads with the new theme
- Switching into an nvim pane after picking → nvim applies the new colorscheme
- New nvim instances start with the current theme from the file
- `PROJECT_THEME=mocha` still overrides the theme file for tmux
- Catppuccin flavors work across all three layers
- Missing theme file or unknown theme name → graceful fallback to citadel
