require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {
    dark0_hard = "#0a0a0a",
  },
  overrides = {
    -- SignColumn = {bg = "#0a0a0a"},
    -- CursorLine = {bg = "#111111"},
    -- CursorLineNr = {bg = "#0a0a0a"}
  },
  dim_inactive = false,
  transparent_mode = true,
})

vim.cmd("colorscheme gruvbox")
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
