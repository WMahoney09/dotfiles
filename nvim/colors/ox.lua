-- Paddy Ox colorscheme
-- Ported from https://github.com/yl92/paddy-color-theme

vim.cmd("hi clear")
vim.g.colors_name = "ox"

local p = {
  -- Structural
  bg = "#1f0c0f",
  fg = "#ecaf87",
  crust = "#140709",
  mantle = "#190a0c",
  surface0 = "#332726",
  surface1 = "#4d3232",
  surface2 = "#5c4242",
  overlay0 = "#6c5252",
  overlay1 = "#7c6262",
  overlay2 = "#8c7272",
  subtext0 = "#a89090",
  subtext1 = "#c4abab",

  -- Syntax (from VSCode Ox tokenColors)
  comment = "#804747",
  variable = "#fdcaa0",
  keyword = "#ceaf76",
  string = "#f48841",
  func = "#c9513c",
  func_call = "#cf553f",
  number = "#ee6941",
  storage = "#bb4c5b",
  control_return = "#699b31",
  conditional = "#5fc75f",
  loop = "#b9b747",
  class = "#ff9b18",
  type = "#bb944c",
  bool_true = "#8bc34b",
  bool_false = "#e25070",
  null = "#927a65",
  regex = "#e96bd8",
  tag = "#5e9c5c",
  operator = "#b87e76",
  operator_logical = "#ffa033",
  operator_comparison = "#a7c458",
  operator_assignment = "#c77048",

  -- UI accents
  accent = "#ff6550",
  accent_warm = "#ffc918",

  -- Diagnostics (from VSCode)
  error = "#c71726",
  warning = "#e98842",
  info = "#73b4ac",
  hint = "#34a125",

  -- Git (from VSCode)
  git_added = "#b8e158",
  git_modified = "#81a897",
  git_deleted = "#ca4e4c",
}

local hl = vim.api.nvim_set_hl

-- ── Core ──────────────────────────────────────────────────────────────────
hl(0, "Normal", { fg = p.fg, bg = p.bg })
hl(0, "NormalFloat", { fg = p.fg, bg = p.mantle })
hl(0, "FloatBorder", { fg = p.overlay0, bg = p.mantle })
hl(0, "CursorLine", { bg = "#2e1a1c" })
hl(0, "CursorLineNr", { fg = p.accent_warm, bold = true })
hl(0, "LineNr", { fg = p.surface2 })
hl(0, "SignColumn", { bg = p.bg })
hl(0, "Visual", { bg = "#3d1e22" })
hl(0, "Search", { fg = p.crust, bg = p.keyword })
hl(0, "IncSearch", { fg = p.crust, bg = p.accent_warm })
hl(0, "CurSearch", { fg = p.crust, bg = p.accent_warm, bold = true })
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
hl(0, "WildMenu", { fg = p.crust, bg = p.accent })

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
hl(0, "TelescopePromptTitle", { fg = p.crust, bg = p.accent, bold = true })
hl(0, "TelescopePreviewTitle", { fg = p.crust, bg = p.hint, bold = true })
hl(0, "TelescopeResultsTitle", { fg = p.crust, bg = p.accent_warm, bold = true })
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
