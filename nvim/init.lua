
--- Bootstrap packer.vim
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('mapping')
require('config')
require('plugins')
require('lualine')
require('nvim-tree-conf')
require('nvim-tabline-conf')
require('treesitter-conf')
require('telescope-conf')
require('nvim-lsp-conf')
require('cmp-conf')
require('lspkind-conf')
require('lspsaga-conf')

