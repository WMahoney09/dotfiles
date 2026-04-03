# Paddy Theme Expansion: Grizzly, Ox, Terabyte

## Overview

Port three additional Paddy color themes — **Grizzly**, **Ox**, and **Terabyte** — across Ghostty, tmux, and nvim. Uses the Citadel implementation (completed in issue #1) as the structural template. All three are dark themes. Builds directly in this dotfiles repo; extraction to standalone repos is deferred to a future issue.

## Notes

- **Out of scope:** Light themes, all 25 Paddy themes, standalone repo extraction, Ghostty config changes beyond palette files.
- **Source material:** Theme JSONs from [yl92/paddy-color-theme](https://github.com/yl92/paddy-color-theme) (`themes/default/Paddy-{grizzly,ox,terabyte}-color-theme.json`).
- **Structural template:** Citadel files are the reference — `ghostty/themes/citadel`, `tmux/themes/citadel.conf`, `nvim/colors/citadel.lua`. The highlight group structure is stable; new themes swap palette values only.
- **Derived colors:** Some values (surfaces, overlays, subtexts, CursorLine bg, Visual bg) are not directly in the VSCode JSON — they were derived for Citadel by darkening/lightening the base background. The same derivation approach applies to each new theme.
- **Ghostty config stays on citadel.** `ghostty/config` hardcodes `theme = citadel`. Per-session visual theming is handled entirely by tmux's `window-style` (pane bg/fg) and nvim's colorscheme. New Ghostty palette files are created for completeness and community use, but Ghostty's active theme does not change per-project.
- **Theme character:**
  - **Grizzly** — warm brown/orange on deep charcoal (`#201612`)
  - **Ox** — bold red/orange on dark burgundy (`#1f0c0f`)
  - **Terabyte** — sage green/cream on dark teal (`#0b1a1a`)

## Progress

- [x] Phase 1a: Grizzly palette extraction + Ghostty + tmux
- [x] Phase 1b: Grizzly nvim colorscheme
- [x] Phase 2: Theme switcher and integration wiring — also fixed hardcoded zoom indicator colors to use @thm_* variables
- [x] Phase 3a: Ox (all layers)
- [x] Phase 3b: Terabyte (all layers)

---

## Phase 1a: Grizzly palette extraction + Ghostty + tmux

Extract the Grizzly palette from the VSCode JSON and build the Ghostty and tmux theme files. These are the more mechanical mappings — editor colors, ANSI palette, and catppuccin variable substitution.

### Step 1a.1: Extract Grizzly palette from VSCode JSON

#### Task 1a.1.1: Fetch `Paddy-grizzly-color-theme.json` from the Paddy repo
Read the full JSON to identify all color values needed.

#### Task 1a.1.2: Map VSCode editor colors to structural palette
Extract: background, foreground, cursor, selection bg/fg, terminal ANSI 0-15. Map to the Ghostty and tmux structural slots.

#### Task 1a.1.3: Derive UI depth colors
From the Grizzly background (`#201612`), derive: crust, mantle, surface0/1/2, overlay0/1/2, subtext0/1. Use the same lightening strategy as Citadel (progressively lighter shades in the same hue family).

### Step 1a.2: Create Ghostty theme

#### Task 1a.2.1: Create `ghostty/themes/grizzly`
Copy `ghostty/themes/citadel` structure, replace all hex values with Grizzly palette.

**Critical file:** `ghostty/themes/grizzly` (new)

### Step 1a.3: Create tmux theme

#### Task 1a.3.1: Create `tmux/themes/grizzly.conf`
Copy `tmux/themes/citadel.conf` structure, replace all `@thm_*` variable values with Grizzly palette. Map ANSI accent colors to catppuccin color names (red, green, yellow, blue, etc.).

**Critical file:** `tmux/themes/grizzly.conf` (new)

---

## Phase 1b: Grizzly nvim colorscheme

The interpretive layer: map VSCode tokenColors to nvim highlight groups and create the colorscheme file. This is where the VSCode→nvim translation requires judgment calls.

### Step 1b.1: Map VSCode tokenColors to nvim syntax palette

#### Task 1b.1.1: Walk the tokenColors array
Map each VSCode scope to the corresponding `local p = {}` key in `citadel.lua`. Document any scopes that don't have a direct Citadel analogue.

### Step 1b.2: Create nvim colorscheme

#### Task 1b.2.1: Create `nvim/colors/grizzly.lua`
Copy `nvim/colors/citadel.lua`, update `vim.g.colors_name`, replace the entire `local p = {}` palette block with Grizzly values. The highlight group definitions below the palette remain structurally identical.

#### Task 1b.2.2: Verify CursorLine, Visual, and other hardcoded bg values
Citadel has a few hardcoded hex values outside the palette table (e.g., `CursorLine bg = "#1e3132"`, `Visual bg = "#493728"`). These need theme-appropriate replacements derived from Grizzly's background.

**Critical file:** `nvim/colors/grizzly.lua` (new)

---

## Phase 2: Theme switcher and integration wiring

Wire the switcher and startup logic before building Ox and Terabyte, so all subsequent themes are validated through the full `PROJECT_THEME` integration path.

### Step 2.1: Update tmux theme switcher

#### Task 2.1.1: Add grizzly, ox, terabyte to the fzf picker list
Update the `printf` in the `bind T` block to include the three new themes.

#### Task 2.1.2: Replace the binary if/else with file-existence check
The current switcher has `if [ "$theme" = "citadel" ]` which only handles one custom theme. Replace with: check if `~/.tmux.conf.d/themes/${theme}.conf` exists — if so, source it; otherwise treat as a catppuccin flavor and source from the plugin directory. This is future-proof: adding a new Paddy theme only requires dropping a conf file and adding the name to the fzf list.

**Critical file:** `tmux/tmux.conf` (modify lines 81-94)

### Step 2.2: Update tmux startup theme detection

#### Task 2.2.1: Replace the `if-shell` block with file-existence check
The current `if-shell` tests `[ "$PROJECT_THEME" != "citadel" ]` which breaks for new Paddy themes (would try to set `@catppuccin_flavor "grizzly"`). Replace with: `if-shell '[ -n "$PROJECT_THEME" ] && [ -f ~/.tmux.conf.d/themes/$PROJECT_THEME.conf ]'` → source the conf file; else branch checks if `PROJECT_THEME` is set (catppuccin flavor) or falls back to sourcing citadel. This handles Paddy themes, catppuccin flavors, and the default case with no hardcoded theme names.

**Critical file:** `tmux/tmux.conf` (modify lines 46-48)

### Step 2.3: Validate full integration with Grizzly

#### Task 2.3.1: Test PROJECT_THEME=grizzly across tmux startup and switcher
Verify that `PROJECT_THEME=grizzly` correctly sources `grizzly.conf` at startup, that the theme switcher lists and activates Grizzly, and that nvim picks up the colorscheme.

#### Task 2.3.2: Verify catppuccin flavors still work
Confirm that `PROJECT_THEME=mocha` (and switcher selection of catppuccin flavors) still works correctly through the new logic.

---

## Phase 3a: Ox (all layers)

With the pattern validated and switcher wired, Ox is pure file creation — no new logic. Independent of Phase 3b.

### Step 3a.1: Extract Ox palette and create theme files

#### Task 3a.1.1: Fetch `Paddy-ox-color-theme.json` and map editor + tokenColors
Same mapping process as Grizzly.

#### Task 3a.1.2: Derive UI depth colors from Ox background (`#1f0c0f`)

#### Task 3a.1.3: Create `ghostty/themes/ox`

**Critical file:** `ghostty/themes/ox` (new)

#### Task 3a.1.4: Create `tmux/themes/ox.conf`

**Critical file:** `tmux/themes/ox.conf` (new)

#### Task 3a.1.5: Create `nvim/colors/ox.lua`
Replace palette and verify derived bg values for CursorLine, Visual, etc.

**Critical file:** `nvim/colors/ox.lua` (new)

---

## Phase 3b: Terabyte (all layers)

Independent of Phase 3a. Pure file creation following the established pattern.

### Step 3b.1: Extract Terabyte palette and create theme files

#### Task 3b.1.1: Fetch `Paddy-terabyte-color-theme.json` and map editor + tokenColors

#### Task 3b.1.2: Derive UI depth colors from Terabyte background (`#0b1a1a`)

#### Task 3b.1.3: Create `ghostty/themes/terabyte`

**Critical file:** `ghostty/themes/terabyte` (new)

#### Task 3b.1.4: Create `tmux/themes/terabyte.conf`

**Critical file:** `tmux/themes/terabyte.conf` (new)

#### Task 3b.1.5: Create `nvim/colors/terabyte.lua`
Replace palette and verify derived bg values for CursorLine, Visual, etc.

**Critical file:** `nvim/colors/terabyte.lua` (new)

---

## Gotchas & Risks

- **Derived colors are subjective.** Surfaces, overlays, and subtexts aren't in the VSCode JSON — they're hand-derived to create visual depth. Each theme's base hue is different (brown, red, teal), so the derivation needs to respect the hue family rather than applying a uniform lightening formula.
- **Hardcoded hex values in citadel.lua.** CursorLine and Visual backgrounds are hardcoded outside the palette table. Easy to miss when copying the template — must be replaced per theme.
- **ANSI-to-catppuccin mapping is interpretive.** The 14 catppuccin accent color names (red, maroon, peach, yellow, green, teal, sky, sapphire, blue, lavender, mauve, pink, flamingo, rosewater) don't map 1:1 to ANSI colors. Each theme needs a judgment call on which Paddy color fills each catppuccin slot.
- **tokenColor scope coverage varies.** Some Paddy themes may define scopes that Citadel doesn't, or omit ones Citadel has. The nvim palette table may need minor additions if a theme has unique syntax distinctions worth preserving.

## Success Criteria

- `PROJECT_THEME=grizzly` / `ox` / `terabyte` each produces a cohesive visual environment across Ghostty, tmux, and nvim
- Theme switcher (`C-a T`) lists and correctly activates all four Paddy themes plus catppuccin flavors
- Syntax highlighting is readable and intentional in each theme (no invisible text, no jarring contrast mismatches)
- All new files follow the exact structure of their Citadel counterparts
- Switcher and startup logic use file-existence checks with no hardcoded theme names (future-proof for additional themes)
