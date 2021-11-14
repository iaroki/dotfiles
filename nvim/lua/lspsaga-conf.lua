local saga = require 'lspsaga'

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<C-j>', '<cmd>Lspsaga diagnostic_jump_next<cr>', opts)
vim.api.nvim_set_keymap('n', 'gh', '<cmd>Lspsaga lsp_finder<cr>', opts)
vim.api.nvim_set_keymap('n', 'gp', '<cmd>Lspsaga preview_definition<cr>', opts)

