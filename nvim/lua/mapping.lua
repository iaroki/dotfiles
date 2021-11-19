vim.api.nvim_set_keymap('', '<C-n>', ':NvimTreeToggle<CR>', {noremap = false})
vim.api.nvim_set_keymap('i', 'kj', '<esc>', {noremap = true})
vim.api.nvim_set_keymap('c', 'kj', '<C-C>', {noremap = true})
vim.api.nvim_set_keymap('t', '<esc>', '<C-\\><C-n>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', {noremap = true})

