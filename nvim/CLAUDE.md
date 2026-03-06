# Neovim Config

This project is a personal Neovim configuration built on [AstroNvim](https://astronvim.com/).

## Project scope

Tasks here are focused on workflow and tooling — configuring Neovim to support an efficient development environment. Expect requests around:

- Editor behavior and options (keymaps, UI, editor settings)
- LSP setup and language tooling
- Plugin configuration and integration
- General developer workflow improvements

## Structure

- `init.lua` — entry point
- `lua/lazy_setup.lua` — lazy.nvim bootstrap
- `lua/community.lua` — AstroNvim community plugins
- `lua/plugins/astrocore.lua` — core options, keymaps, and autocommands (activated)
- `lua/plugins/astrolsp.lua` — LSP configuration (guarded, not yet activated)
- `lua/plugins/astroui.lua` — UI/theme configuration (guarded)
- `lua/plugins/mason.lua` — auto-installed LSPs and tools via Mason
- `lua/plugins/treesitter.lua` — Treesitter language parsers
- `lua/plugins/user.lua` — custom plugin additions (guarded)
- `lua/plugins/none-ls.lua` — none-ls (null-ls) configuration (guarded)
- `lua/plugins/markdown.lua` — markdown-specific config
- `lua/polish.lua` — final setup hook (guarded)

## Notes

- Several files ship with a guard (`if true then return {} end`) that prevents them from loading — these are AstroNvim templates. Remove the guard to activate a file.
- `astrocore.lua` is active and is the right place for vim options and keymaps.
- Mason auto-installs: `lua-language-server`, `stylua`, `typescript-language-server`, `eslint-lsp`, `prettierd`.
