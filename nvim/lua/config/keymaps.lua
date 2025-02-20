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
map('n', '<leader>1', ':BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true })
map('n', '<leader>2', ':BufferLineGoToBuffer 2<CR>', { noremap = true, silent = true })
map('n', '<leader>3', ':BufferLineGoToBuffer 3<CR>', { noremap = true, silent = true })
map('n', '<leader>4', ':BufferLineGoToBuffer 4<CR>', { noremap = true, silent = true })
map('n', '<leader>5', ':BufferLineGoToBuffer 5<CR>', { noremap = true, silent = true })

-- NeoTree mappings
map('n', '<C-n>', ':Neotree toggle<CR>', { noremap = true, silent = true })
map('n', '<leader>R', ':NvimTreeRefresh<CR>', { noremap = true, silent = false })
map('n', '<leader>N', ':NvimTreeFindFile<CR>', { noremap = true, silent = false })

-- ToggleTerm mappings
map('n', '<C-\\>', ':ToggleTerm<CR>', { noremap = true, silent = true })

-- Telescope mappings
map('n', '<leader>tf', ':Telescope find_files<CR>', { noremap = true, silent = false })
map('n', '<leader>tg', ':Telescope live_grep<CR>', { noremap = true, silent = false })

-- Hop mappings
map('n', '<leader>hl', ':HopLine<CR>', { noremap = true, silent = false })
map('n', '<leader>hL', ':HopLineStart<CR>', { noremap = true, silent = false })
map('n', '<leader>hw', ':HopWord<CR>', { noremap = true, silent = false })

-- Gitsigns mappings
map('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { noremap = true, silent = false })

-- Neogit mappings
map('n', '<leader>ng', ':Neogit<CR>', { noremap = true, silent = false })

-- Telekasten mappings
map('n', '<leader>z', ':Telekasten panel<CR>', { noremap = true, silent = false })
map('n', '<leader>zn', ':Telekasten new_note<CR>', { noremap = true, silent = false })
map('n', '<leader>zf', ':Telekasten find_notes<CR>', { noremap = true, silent = false })
map('n', '<leader>zg', ':Telekasten search_notes<CR>', { noremap = true, silent = false })

-- Harpoon mappings
map('n', '<leader>ht', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, silent = false })
map('n', '<leader>ha', ':lua require("harpoon.mark").add_file()<CR>', { noremap = true, silent = false })
map('n', '<leader>hn', ':lua require("harpoon.ui").nav_next()<CR>', { noremap = true, silent = false })
map('n', '<leader>hp', ':lua require("harpoon.ui").nav_prev()<CR>', { noremap = true, silent = false })
map('n', '<leader>h1', ':lua require("harpoon.ui").nav_file(1)<CR>', { noremap = true, silent = false })
map('n', '<leader>h2', ':lua require("harpoon.ui").nav_file(2)<CR>', { noremap = true, silent = false })
map('n', '<leader>h3', ':lua require("harpoon.ui").nav_file(3)<CR>', { noremap = true, silent = false })

-- Git-trees mappings
map('n', '<leader>gwl', ':lua require("telescope").extensions.git_worktree.git_worktrees()<CR>', { noremap = true, silent = false })
map('n', '<leader>gwa', ':lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>', { noremap = true, silent = false })

-- Kubectl mappings
map('n', '<leader>k', ':lua require("kubectl").toggle()<CR>', { noremap = true, silent = false })
