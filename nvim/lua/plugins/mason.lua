---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Lua
        "lua-language-server",
        "stylua",

        -- TypeScript / JavaScript
        "typescript-language-server",
        "eslint-lsp",
        "prettierd",
      },
    },
  },
}
