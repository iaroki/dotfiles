
return require('packer').startup(function()

use { 'wbthomason/packer.nvim' }
use { 'neovim/nvim-lspconfig' }
use { 'hrsh7th/cmp-nvim-lsp' }
use { 'hrsh7th/cmp-buffer' }
use { 'hrsh7th/cmp-path' }
use { 'hrsh7th/nvim-cmp' }
use { 'hrsh7th/cmp-vsnip' }
use { 'hrsh7th/vim-vsnip' }
use { 'onsails/lspkind-nvim' }
use { 'glepnir/lspsaga.nvim' }
use { 'nvim-lua/popup.nvim' }
use { 'nvim-lua/plenary.nvim' }
use { 'nvim-telescope/telescope.nvim' }
use { 'kyazdani42/nvim-web-devicons' }
use { 'kyazdani42/nvim-tree.lua' }
use { 'hoob3rt/lualine.nvim' }
use { 'crispgm/nvim-tabline' }
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
use { 'p00f/nvim-ts-rainbow' }
use { 'gruvbox-community/gruvbox' }
use { 'preservim/tagbar' }
use { 'tpope/vim-surround' }
use { 'tpope/vim-commentary' }
use { 'tpope/vim-fugitive' }
use { 'airblade/vim-gitgutter' }
use { 'ntpeters/vim-better-whitespace' }
use { 'Yggdroot/indentLine' }

end)

