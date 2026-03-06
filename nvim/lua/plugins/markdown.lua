---@type LazySpec
return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/markdown.css")

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("n", "<Leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { buffer = true, desc = "Markdown Preview Toggle" })
        end,
      })
    end,
  },
}
