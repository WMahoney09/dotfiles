# Build Paddy Citadel Theme Across Ghostty, tmux, and nvim

## Overview

Port the Citadel color palette from the [Paddy color theme](https://github.com/yl92/paddy-color-theme) VSCode extension to Ghostty, tmux, and nvim. This is the R&D phase — figure out the mapping layer for each tool so future Paddy themes can be ported mechanically.

tmux theming uses catppuccin/tmux as the structural engine (powerline, status modules, window tabs) with Citadel colors mapped to catppuccin's `@thm_*` variables. tmux `window-style` sets pane bg/fg for full session theming. The theme switcher (`C-a T`) offers Citadel alongside catppuccin's built-in flavors.

## Notes

- **Out of scope:** tmuxinator layout files, nvim treesitter/LSP semantic token mapping (Phase 2 concern), other Paddy themes beyond Citadel.
- **Ghostty inclusion rationale:** Not strictly needed for our workflow (tmux `window-style` handles pane theming), but avoids palette clashes and sets up the open-source port (Issue #2).
- **nvim approach:** Create a standalone colorscheme plugin file within the dotfiles nvim config. Activate `astroui.lua` and `community.lua` (currently guarded). The env var integration (`PROJECT_THEME`) is included so tmuxinator can drive it later.
- **catppuccin coexistence:** The theme switcher offers both catppuccin flavors (mocha, macchiato, frappe, latte) and Citadel. They share the same `@thm_*` variable interface.

## Citadel Color Reference

Source: `themes/default/Paddy-citadel-color-theme.json`

| Role | Hex |
|---|---|
| editor.background | `#092630` |
| editor.foreground | `#e3b19d` |
| statusBar.background | `#092630` |
| statusBar.foreground | `#4bccb7` |
| terminal.foreground | `#03b698` |
| ansiBlack | `#205263` |
| ansiRed | `#ff4128` |
| ansiGreen | `#14ad35` |
| ansiYellow | `#eba31c` |
| ansiBlue | `#173fc3` |
| ansiMagenta | `#db0f8d` |
| ansiCyan | `#03d6dd` |
| ansiWhite | `#e3b19d` |
| ansiBrightBlack | `#215769` |
| ansiBrightRed | `#ff5a44` |
| ansiBrightGreen | `#48ec7f` |
| ansiBrightYellow | `#ffd54c` |
| ansiBrightBlue | `#509fff` |
| ansiBrightMagenta | `#ff46c8` |
| ansiBrightCyan | `#8febf2` |
| ansiBrightWhite | `#fae8e0` |

## Progress

- [x] Phase 1: Ghostty Citadel theme (LOE 1)
- [x] Phase 2: tmux Citadel theme — catppuccin `@thm_*` mapping (LOE 2)
- [x] Phase 3: tmux config cleanup and switcher update (LOE 2)
- [x] Phase 4a: nvim Citadel colorscheme — core + syntax highlights (LOE 2)
- [x] Phase 4b: nvim Citadel colorscheme — plugin + diagnostic highlights (LOE 2) — combined with 4a into single colors/citadel.lua file
- [x] Phase 4c: AstroNvim integration + env var wiring (LOE 1)

---

## Phase 1: Ghostty Citadel Theme

### Step 1.1: Create the Ghostty theme file

#### Task 1.1.1: Create `ghostty/themes/` directory and `citadel` theme file

Map Citadel's terminal colors to Ghostty's theme format:
- `background`, `foreground`, `cursor-color`
- `palette = 0-15` (16 ANSI colors from the reference table above)
- `selection-background`, `selection-foreground`

#### Task 1.1.2: Update `ghostty/config` to use the Citadel theme

Change `theme = dracula` to `theme = citadel`.

### Critical files
- **Create:** `ghostty/themes/citadel`
- **Modify:** `ghostty/config`

### Gotchas
- Ghostty theme files cannot contain a `theme` key (silently ignored).
- The `ghostty/` directory is symlinked to `~/.config/ghostty`, so the `themes/` subdirectory will be in the right place automatically.

---

## Phase 2: tmux Citadel Theme (catppuccin `@thm_*` mapping)

### Step 2.1: Map Citadel colors to catppuccin's 26 `@thm_*` variables

#### Task 2.1.1: Create `tmux/themes/citadel.conf`

Map Citadel's palette to catppuccin's variable interface. Uses `set -gq` (not `-ogq`) so values override at runtime. The mapping decisions:

| catppuccin variable | Citadel mapping | Rationale |
|---|---|---|
| `@thm_bg` | `#092630` | editor.background |
| `@thm_fg` | `#e3b19d` | editor.foreground |
| `@thm_crust` | `#051a22` | darkened bg (anchor) |
| `@thm_mantle` | `#071e28` | between crust and bg |
| `@thm_surface_0` | `#205263` | ansiBlack (darkest visible surface) |
| `@thm_surface_1` | `#215769` | ansiBrightBlack |
| `@thm_surface_2` | `#2a6a7d` | interpolated mid-surface |
| `@thm_overlay_0` | `#3a7a8d` | muted UI borders |
| `@thm_overlay_1` | `#4a8a9d` | subtle highlights |
| `@thm_overlay_2` | `#5a9aad` | more prominent highlights |
| `@thm_subtext_0` | `#8fbcb0` | muted text |
| `@thm_subtext_1` | `#b3d4c8` | slightly brighter muted text |
| `@thm_red` | `#ff4128` | ansiRed |
| `@thm_maroon` | `#ff5a44` | ansiBrightRed (softer red) |
| `@thm_peach` | `#eba31c` | ansiYellow (warm accent) |
| `@thm_yellow` | `#ffd54c` | ansiBrightYellow |
| `@thm_green` | `#14ad35` | ansiGreen |
| `@thm_teal` | `#03b698` | terminal.foreground (primary teal) |
| `@thm_sky` | `#03d6dd` | ansiCyan |
| `@thm_sapphire` | `#8febf2` | ansiBrightCyan |
| `@thm_blue` | `#509fff` | ansiBrightBlue |
| `@thm_lavender` | `#4bccb7` | statusBar.foreground (accent) |
| `@thm_mauve` | `#db0f8d` | ansiMagenta |
| `@thm_pink` | `#ff46c8` | ansiBrightMagenta |
| `@thm_flamingo` | `#e3b19d` | warm neutral (editor.foreground) |
| `@thm_rosewater` | `#fae8e0` | ansiBrightWhite (warmest light) |

**Note for visual tuning:** The interpolated values (`crust`, `mantle`, `surface_2`, `overlay_*`, `subtext_*`) are derived rather than directly from Citadel's palette. These control subtle UI gradients and may need adjustment by eye.

### Critical files
- **Create:** `tmux/themes/citadel.conf`

### Gotchas
- Must use `set -gq` not `set -ogq` — the `-o` flag prevents overriding existing values, which breaks theme switching.

---

## Phase 3: tmux Config Cleanup and Switcher Update

### Step 3.1: Add `window-style` for pane theming

#### Task 3.1.1: Add pane bg/fg to tmux.conf

Set `window-style` and `window-active-style` using `set -gF` (capital F forces format expansion). Example: `set -gF window-style "bg=#{@thm_bg},fg=#{@thm_fg}"`. Verified that `-gF` resolves `@thm_*` variables to hex values; plain `-g` stores the literal string.

### Step 3.2: Update the theme switcher

#### Task 3.2.1: Add Citadel to the `C-a T` fzf list

Rewrite the switcher with branching logic:
- List includes both catppuccin flavors and `citadel`
- If selection is a catppuccin flavor → source from `~/.tmux/plugins/tmux/themes/catppuccin_${flavor}_tmux.conf` with `sed` to strip `-ogq`
- If selection is `citadel` → source from `~/.tmux.conf.d/themes/citadel.conf` directly (already uses `-gq`)
- After either path, re-source `catppuccin_tmux.conf` to apply structural styling with new colors
- After either path, `set -gF window-style` and `set -gF window-active-style` to update pane bg/fg
- Re-set `status-right` to refresh status modules

#### Task 3.2.2: Update the env var logic

Rename `TMUX_THEME` to `PROJECT_THEME` (shared with nvim). Update the `if-shell` in tmux.conf to read `PROJECT_THEME` and handle both catppuccin flavors and custom themes.

### Step 3.3: Clean up tmux.conf

#### Task 3.3.1: Remove stale tmux-battery plugin reference

Verify no blank line or orphaned config remains from the earlier battery removal. Note: the plugin files still exist at `~/.tmux/plugins/tmux-battery/` — run `prefix + alt + u` (TPM clean) to remove them.

### Critical files
- **Modify:** `tmux/tmux.conf`

### Gotchas
- The switcher needs two code paths: catppuccin built-in themes (source from plugin dir with `sed`) vs custom themes like Citadel (source directly from `tmux/themes/`).
- `window-style` requires `set -gF` (capital F) for format expansion. Plain `set -g` stores literal strings. Verified this works.

---

## Phase 4a: nvim Citadel Colorscheme — Core + Syntax Highlights

### Step 4a.1: Create the colorscheme plugin

#### Task 4a.1.1: Create `nvim/lua/plugins/citadel.lua`

A lazy.nvim plugin spec that defines the Citadel colorscheme and registers it as `citadel` so it can be set via `vim.cmd.colorscheme("citadel")`. This phase covers:
- **Core highlights:** Normal, NormalFloat, CursorLine, CursorLineNr, Visual, Search, IncSearch, StatusLine, StatusLineNC, LineNr, SignColumn, Pmenu, PmenuSel, etc.
- **Syntax highlights:** via treesitter captures (`@function`, `@variable`, `@variable.parameter`, `@keyword`, `@string`, `@comment`, `@type`, `@constant`, `@operator`, `@punctuation`, etc.)

### Critical files
- **Create:** `nvim/lua/plugins/citadel.lua`

### Gotchas
- The colorscheme must register itself via `vim.api.nvim_create_user_command` or the `colors/` directory convention. For a plugin-based approach, define a setup function that sets all highlight groups.

---

## Phase 4b: nvim Citadel Colorscheme — Plugin + Diagnostic Highlights

### Step 4b.1: Add plugin-specific highlight groups

#### Task 4b.1.1: Extend `nvim/lua/plugins/citadel.lua` with plugin highlights

Add highlight groups for plugins active in the AstroNvim config:
- **Diagnostics:** DiagnosticError, DiagnosticWarn, DiagnosticInfo, DiagnosticHint, and their underline/virtual text variants
- **Telescope:** TelescopeNormal, TelescopeBorder, TelescopePrompt*, TelescopeSelection, TelescopeMatching
- **Gitsigns:** GitSignsAdd, GitSignsChange, GitSignsDelete
- **Neo-tree:** NeoTreeNormal, NeoTreeDirectoryIcon, NeoTreeGitModified, etc.
- **Indent-blankline:** IblIndent, IblScope
- **nvim-cmp:** CmpItemAbbr, CmpItemKind*, CmpItemMenu

### Critical files
- **Modify:** `nvim/lua/plugins/citadel.lua`

### Gotchas
- Scope to plugins actually installed. Check `~/.local/share/nvim/lazy/` to confirm which are present rather than guessing.
- Plugin highlight groups change across versions — use current AstroNvim defaults as reference.

---

## Phase 4c: AstroNvim Integration + Env Var Wiring

### Step 4c.1: Activate astroui.lua and wire up env var

#### Task 4c.1.1: Remove the guard from `astroui.lua`

Remove `if true then return {} end`. Set colorscheme based on `PROJECT_THEME` env var with fallback to `astrodark`.

### Step 4c.2: Activate community.lua for catppuccin-nvim (optional)

#### Task 4c.2.1: Enable community.lua and add catppuccin import

Remove the guard. Replace the example `{ import = "astrocommunity.pack.lua" }` line with a catppuccin import. This keeps catppuccin as an available nvim colorscheme alongside Citadel, matching the tmux setup where both are available.

### Critical files
- **Modify:** `nvim/lua/plugins/astroui.lua`
- **Modify:** `nvim/lua/community.lua` (optional)

### Gotchas
- AstroNvim's `astroui` opts expect a colorscheme name string. The env var logic goes in this file.
- `community.lua`: `astrocommunity` is not currently installed. lazy.nvim will fetch it on first launch after activation. First nvim launch after this change will trigger a plugin install.

---

## Success Criteria

1. **Ghostty:** `ghostty +list-themes` includes `citadel`. Launching Ghostty with `theme = citadel` shows Citadel's dark teal background and warm foreground.
2. **tmux:** `C-a T` offers Citadel alongside catppuccin flavors. Selecting Citadel changes status bar colors, pane background/foreground, and pane borders. Switching back to a catppuccin flavor restores its colors.
3. **nvim:** Opening nvim in a session with `PROJECT_THEME=citadel` loads the Citadel colorscheme. Syntax highlighting uses Citadel's palette. Falling back to no env var loads `astrodark`.
4. **Round-trip:** Switching themes in tmux and restarting nvim in the same session picks up the correct theme in both tools.
