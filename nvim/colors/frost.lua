-- Paddy Frost colorscheme (light)
-- Ported from https://github.com/yl92/paddy-color-theme

vim.cmd("hi clear")
vim.g.colors_name = "frost"

local p = {
  -- Structural (light theme: depth goes bg → crust darker)
  bg = "#f6faf8",
  fg = "#186554",
  crust = "#d3e4e1",
  mantle = "#e3f0ee",
  surface0 = "#bfdad7",
  surface1 = "#a8c8c2",
  surface2 = "#90b5ae",
  overlay0 = "#78a29a",
  overlay1 = "#608f86",
  overlay2 = "#4a7c72",
  subtext0 = "#346960",
  subtext1 = "#245a50",

  -- Syntax (from VSCode Frost tokenColors)
  comment = "#a8b3b0",
  variable = "#186554",
  keyword = "#796641",
  string = "#cc894b",
  func = "#f16a41",
  func_call = "#e6541b",
  number = "#b34d34",
  storage = "#b37570",
  control_return = "#1d8b19",
  conditional = "#49a7ac",
  loop = "#a3a111",
  class = "#daba62",
  type = "#c49b43",
  bool_true = "#19c452",
  bool_false = "#d15f96",
  null = "#728681",
  regex = "#e42ebc",
  tag = "#1aa572",
  operator = "#91534b",
  operator_logical = "#d18a1f",
  operator_comparison = "#73ad2f",
  operator_assignment = "#ac5050",

  -- UI accents
  accent = "#098a3a",
  accent_warm = "#d37d0d",

  -- Diagnostics (from VSCode)
  error = "#ff5c69",
  warning = "#ffa05b",
  info = "#72bdb4",
  hint = "#58be4a",

  -- Git (from VSCode)
  git_added = "#9fc487",
  git_modified = "#6da396",
  git_deleted = "#be4c4a",
}

local hl = vim.api.nvim_set_hl

-- ── Core ──────────────────────────────────────────────────────────────────
hl(0, "Normal", { fg = p.fg, bg = p.bg })
hl(0, "NormalFloat", { fg = p.fg, bg = p.mantle })
hl(0, "FloatBorder", { fg = p.overlay0, bg = p.mantle })
hl(0, "CursorLine", { bg = "#edf7f3" })
hl(0, "CursorLineNr", { fg = p.accent_warm, bold = true })
hl(0, "LineNr", { fg = p.surface2 })
hl(0, "SignColumn", { bg = p.bg })
hl(0, "Visual", { bg = "#badfd1" })
hl(0, "Search", { fg = p.bg, bg = p.keyword })
hl(0, "IncSearch", { fg = p.bg, bg = p.accent_warm })
hl(0, "CurSearch", { fg = p.bg, bg = p.accent_warm, bold = true })
hl(0, "StatusLine", { fg = p.fg, bg = p.mantle })
hl(0, "StatusLineNC", { fg = p.subtext0, bg = p.crust })
hl(0, "WinSeparator", { fg = p.surface1 })
hl(0, "Pmenu", { fg = p.fg, bg = p.mantle })
hl(0, "PmenuSel", { fg = p.fg, bg = p.surface1 })
hl(0, "PmenuSbar", { bg = p.surface0 })
hl(0, "PmenuThumb", { bg = p.overlay0 })
hl(0, "TabLine", { fg = p.subtext0, bg = p.mantle })
hl(0, "TabLineSel", { fg = p.fg, bg = p.bg, bold = true })
hl(0, "TabLineFill", { bg = p.crust })
hl(0, "MatchParen", { fg = p.accent_warm, bold = true, underline = true })
hl(0, "Folded", { fg = p.overlay1, bg = p.surface0 })
hl(0, "FoldColumn", { fg = p.overlay0 })
hl(0, "NonText", { fg = p.surface1 })
hl(0, "SpecialKey", { fg = p.surface2 })
hl(0, "Directory", { fg = p.accent })
hl(0, "Title", { fg = p.accent, bold = true })
hl(0, "ErrorMsg", { fg = p.error, bold = true })
hl(0, "WarningMsg", { fg = p.warning })
hl(0, "ModeMsg", { fg = p.fg, bold = true })
hl(0, "MoreMsg", { fg = p.accent })
hl(0, "Question", { fg = p.accent })
hl(0, "WildMenu", { fg = p.bg, bg = p.accent })

-- ── Legacy Vim syntax groups ──────────────────────────────────────────────
hl(0, "Comment", { fg = p.comment, italic = true })
hl(0, "Constant", { fg = p.number })
hl(0, "String", { fg = p.string })
hl(0, "Identifier", { fg = p.variable })
hl(0, "Function", { fg = p.func })
hl(0, "Statement", { fg = p.keyword })
hl(0, "PreProc", { fg = p.variable })
hl(0, "Type", { fg = p.type, italic = true, underline = true })
hl(0, "Special", { fg = p.keyword })

-- TypeScript-specific syntax overrides
hl(0, "typescriptClassStatic", { fg = p.storage, italic = true })

-- ── Syntax (Treesitter) ──────────────────────────────────────────────────
hl(0, "@variable", { fg = p.variable })
hl(0, "@variable.parameter", { fg = p.variable, italic = true })
hl(0, "@variable.builtin", { fg = p.storage, italic = true })
hl(0, "@variable.member", { fg = p.variable })
hl(0, "@constant", { fg = p.number })
hl(0, "@constant.builtin", { fg = p.null })
hl(0, "@string", { fg = p.string })
hl(0, "@string.escape", { fg = p.control_return })
hl(0, "@string.regex", { fg = p.regex })
hl(0, "@character", { fg = p.string })
hl(0, "@number", { fg = p.number })
hl(0, "@boolean", { fg = p.bool_true })
hl(0, "@function", { fg = p.func, bold = true })
hl(0, "@function.builtin", { fg = p.func, italic = true })
hl(0, "@function.call", { fg = p.func_call, italic = true })
hl(0, "@function.method", { fg = p.func })
hl(0, "@function.method.call", { fg = p.func_call, italic = true })
hl(0, "@constructor", { fg = p.class, bold = true })
hl(0, "@keyword", { fg = p.keyword })
hl(0, "@keyword.function", { fg = p.keyword })
hl(0, "@keyword.return", { fg = p.control_return, italic = true })
hl(0, "@keyword.operator", { fg = p.operator_logical })
hl(0, "@keyword.conditional", { fg = p.conditional })
hl(0, "@keyword.repeat", { fg = p.loop })
hl(0, "@keyword.import", { fg = p.keyword })
hl(0, "@keyword.exception", { fg = p.error })
hl(0, "@keyword.storage", { fg = p.storage, italic = true })
hl(0, "@type", { fg = p.type, italic = true, underline = true })
hl(0, "@type.builtin", { fg = p.type, italic = true, underline = true })
hl(0, "@type.qualifier", { fg = p.keyword })
hl(0, "@operator", { fg = p.operator })
hl(0, "@punctuation", { fg = p.overlay2 })
hl(0, "@punctuation.bracket", { fg = p.overlay2 })
hl(0, "@punctuation.delimiter", { fg = p.overlay2 })
hl(0, "@punctuation.special", { fg = p.operator })
hl(0, "@comment", { fg = p.comment, italic = true })
hl(0, "@tag", { fg = p.tag, bold = true })
hl(0, "@tag.attribute", { fg = p.keyword, italic = true })
hl(0, "@tag.delimiter", { fg = p.overlay2 })
hl(0, "@markup.heading", { fg = p.accent, bold = true })
hl(0, "@markup.link", { fg = p.accent, underline = true })
hl(0, "@markup.link.url", { fg = p.accent, underline = true })
hl(0, "@markup.strong", { bold = true })
hl(0, "@markup.italic", { italic = true })
hl(0, "@markup.strikethrough", { strikethrough = true })
hl(0, "@markup.raw", { fg = p.string })

-- ── Diagnostics ──────────────────────────────────────────────────────────
hl(0, "DiagnosticError", { fg = p.error })
hl(0, "DiagnosticWarn", { fg = p.warning })
hl(0, "DiagnosticInfo", { fg = p.info })
hl(0, "DiagnosticHint", { fg = p.hint })
hl(0, "DiagnosticUnderlineError", { sp = p.error, undercurl = true })
hl(0, "DiagnosticUnderlineWarn", { sp = p.warning, undercurl = true })
hl(0, "DiagnosticUnderlineInfo", { sp = p.info, undercurl = true })
hl(0, "DiagnosticUnderlineHint", { sp = p.hint, undercurl = true })
hl(0, "DiagnosticVirtualTextError", { fg = p.error, bg = p.mantle })
hl(0, "DiagnosticVirtualTextWarn", { fg = p.warning, bg = p.mantle })
hl(0, "DiagnosticVirtualTextInfo", { fg = p.info, bg = p.mantle })
hl(0, "DiagnosticVirtualTextHint", { fg = p.hint, bg = p.mantle })
hl(0, "DiagnosticUnnecessary", { sp = p.overlay2, underline = true })

-- ── LSP Semantic Tokens ────────────────────────────────────────────────
hl(0, "@lsp.type.class", { fg = p.class, bold = true })
hl(0, "@lsp.type.keyword", { fg = p.keyword })
hl(0, "@lsp.type.decorator", { fg = p.func })
hl(0, "@lsp.type.enum", { fg = p.type })
hl(0, "@lsp.type.enumMember", { fg = p.number })
hl(0, "@lsp.type.function", { fg = p.func_call, italic = true })
hl(0, "@lsp.type.interface", { fg = p.type, italic = true })
hl(0, "@lsp.type.macro", { fg = p.keyword })
hl(0, "@lsp.type.member", { fg = p.func_call })
hl(0, "@lsp.type.method", { fg = p.func_call, italic = true })
hl(0, "@lsp.type.namespace", { fg = p.keyword })
hl(0, "@lsp.type.parameter", { fg = p.variable, italic = true })
hl(0, "@lsp.type.property", { fg = p.variable })
hl(0, "@lsp.type.struct", { fg = p.type })
hl(0, "@lsp.type.type", { fg = p.type })
hl(0, "@lsp.type.typeParameter", { fg = p.type, italic = true })
hl(0, "@lsp.type.variable", { fg = p.variable })
hl(0, "@lsp.mod.declaration", {})
hl(0, "@lsp.mod.readonly", { bold = true })
hl(0, "@lsp.typemod.class.declaration", { fg = p.class, bold = true })
hl(0, "@lsp.typemod.function.declaration", { fg = p.func, bold = true, italic = false })
hl(0, "@lsp.typemod.member.declaration", { fg = p.func, bold = true })
hl(0, "@lsp.typemod.member.defaultLibrary", { fg = p.func_call, italic = true })
hl(0, "@lsp.typemod.method.declaration", { fg = p.func, bold = true, italic = false })
hl(0, "@lsp.typemod.variable.readonly", { fg = p.number, bold = true })

-- ── Telescope ────────────────────────────────────────────────────────────
hl(0, "TelescopeNormal", { fg = p.fg, bg = p.mantle })
hl(0, "TelescopeBorder", { fg = p.overlay0, bg = p.mantle })
hl(0, "TelescopePromptNormal", { fg = p.fg, bg = p.surface0 })
hl(0, "TelescopePromptBorder", { fg = p.surface0, bg = p.surface0 })
hl(0, "TelescopePromptTitle", { fg = p.bg, bg = p.accent, bold = true })
hl(0, "TelescopePreviewTitle", { fg = p.bg, bg = p.hint, bold = true })
hl(0, "TelescopeResultsTitle", { fg = p.bg, bg = p.accent_warm, bold = true })
hl(0, "TelescopeSelection", { bg = p.surface0 })
hl(0, "TelescopeMatching", { fg = p.accent, bold = true })

-- ── Gitsigns ─────────────────────────────────────────────────────────────
hl(0, "GitSignsAdd", { fg = p.git_added })
hl(0, "GitSignsChange", { fg = p.git_modified })
hl(0, "GitSignsDelete", { fg = p.git_deleted })

-- ── Neo-tree ─────────────────────────────────────────────────────────────
hl(0, "NeoTreeNormal", { fg = p.fg, bg = p.mantle })
hl(0, "NeoTreeNormalNC", { fg = p.fg, bg = p.mantle })
hl(0, "NeoTreeDirectoryIcon", { fg = p.accent })
hl(0, "NeoTreeDirectoryName", { fg = p.accent })
hl(0, "NeoTreeGitModified", { fg = p.git_modified })
hl(0, "NeoTreeGitAdded", { fg = p.git_added })
hl(0, "NeoTreeGitDeleted", { fg = p.git_deleted })
hl(0, "NeoTreeGitConflict", { fg = p.error, bold = true })
hl(0, "NeoTreeGitUntracked", { fg = p.git_modified })
hl(0, "NeoTreeIndentMarker", { fg = p.surface1 })
hl(0, "NeoTreeRootName", { fg = p.accent, bold = true })

-- ── Indent-blankline ─────────────────────────────────────────────────────
hl(0, "IblIndent", { fg = p.surface0 })
hl(0, "IblScope", { fg = p.accent })

-- ── nvim-cmp ─────────────────────────────────────────────────────────────
hl(0, "CmpItemAbbr", { fg = p.fg })
hl(0, "CmpItemAbbrMatch", { fg = p.accent, bold = true })
hl(0, "CmpItemAbbrMatchFuzzy", { fg = p.accent })
hl(0, "CmpItemMenu", { fg = p.subtext0 })
hl(0, "CmpItemKindFunction", { fg = p.func })
hl(0, "CmpItemKindMethod", { fg = p.func })
hl(0, "CmpItemKindVariable", { fg = p.variable })
hl(0, "CmpItemKindKeyword", { fg = p.keyword })
hl(0, "CmpItemKindText", { fg = p.fg })
hl(0, "CmpItemKindSnippet", { fg = p.string })
hl(0, "CmpItemKindField", { fg = p.variable })
hl(0, "CmpItemKindProperty", { fg = p.variable })
hl(0, "CmpItemKindClass", { fg = p.class })
hl(0, "CmpItemKindInterface", { fg = p.type })
hl(0, "CmpItemKindModule", { fg = p.keyword })
hl(0, "CmpItemKindConstant", { fg = p.number })
