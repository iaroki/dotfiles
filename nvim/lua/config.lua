
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.cmd('colorscheme gruvbox')
vim.cmd('syntax enable')
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.laststatus = 2
vim.g.showmode = false
vim.g.backup = false
vim.g.writebackup = false
vim.g.swapfile = false
vim.g.cursorline = true
vim.g.splitbelow = true
vim.g.splitright = true

vim.g['indentLine_color_dark'] = '1'
vim.g['indentLine_char'] = '┊'
vim.g['better_whitespace_enabled'] = '1'
vim.g['strip_whitespace_on_save'] = '1'
vim.g['rainbow_active'] = '1'

-- Highlight on yank
vim.cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'

