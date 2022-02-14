vim.g.mapleader = ' '

local map = vim.api.nvim_set_keymap

map('n', '<C-h>', '<C-w>h', { noremap = true, silent = false })
map('n', '<C-l>', '<C-w>l', { noremap = true, silent = false })
map('n', '<C-j>', '<C-w>j', { noremap = true, silent = false })
map('n', '<C-k>', '<C-w>k', { noremap = true, silent = false })
map('i', 'jk', '<ESC>', { noremap = true, silent = false })
map('i', 'kj', '<ESC>', { noremap = true, silent = false })
map('v', '<', '<gv', { noremap = true, silent = false })
map('v', '>', '>gv', { noremap = true, silent = false })
map('n', '<leader>w', ':bdelete<CR>', { noremap = true, silent = false })

-- Bufferline mappings
map('n', '<TAB>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
map('n', '<S-TAB>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

-- NvimTree mappings
map('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
map('n', '<leader>R', ':NvimTreeRefresh<CR>', { noremap = true, silent = false })
map('n', '<leader>N', ':NvimTreeFindFile<CR>', { noremap = true, silent = false })

-- Telescope mappings
map('n', '<leader>tf', ':Telescope find_files<CR>', { noremap = true, silent = false })
map('n', '<leader>tg', ':Telescope live_grep<CR>', { noremap = true, silent = false })

-- Hop mappings
map('n', '<leader>hl', ':HopLine<CR>', { noremap = true, silent = false })
map('n', '<leader>hL', ':HopLineStart<CR>', { noremap = true, silent = false })
map('n', '<leader>hw', ':HopWord<CR>', { noremap = true, silent = false })

-- Gitsigns mappings
map('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { noremap = true, silent = false })
