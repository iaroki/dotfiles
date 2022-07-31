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
map('n', '<leader>w', ':b#|bd#<CR>', { noremap = true, silent = false })

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

-- Harpoon mappings
map('n', '<leader>ht', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, silent = false })
map('n', '<leader>ha', ':lua require("harpoon.mark").add_file()<CR>', { noremap = true, silent = false })
map('n', '<leader>hn', ':lua require("harpoon.ui").nav_next()<CR>', { noremap = true, silent = false })
map('n', '<leader>hp', ':lua require("harpoon.ui").nav_prev()<CR>', { noremap = true, silent = false })
map('n', '<leader>h1', ':lua require("harpoon.ui").nav_file(1)<CR>', { noremap = true, silent = false })
map('n', '<leader>h2', ':lua require("harpoon.ui").nav_file(2)<CR>', { noremap = true, silent = false })
map('n', '<leader>h3', ':lua require("harpoon.ui").nav_file(3)<CR>', { noremap = true, silent = false })
