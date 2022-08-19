local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  use {'wbthomason/packer.nvim'}
  use {'gruvbox-community/gruvbox'}
  use {'rebelot/kanagawa.nvim'}
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use {'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true}}
  use {'akinsho/bufferline.nvim', tag = 'v2.*', requires = {'kyazdani42/nvim-web-devicons'}}
  use {'kyazdani42/nvim-tree.lua', requires = {'kyazdani42/nvim-web-devicons'}}
  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'}}
  use {'neovim/nvim-lspconfig'}
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/cmp-buffer'}
  use {'hrsh7th/cmp-path'}
  use {'hrsh7th/cmp-cmdline'}
  use {'hrsh7th/nvim-cmp'}
  use {'hrsh7th/cmp-vsnip'}
  use {'hrsh7th/vim-vsnip'}
  use {'onsails/lspkind-nvim'}
  use {'glepnir/lspsaga.nvim', branch = 'main'}
  use {'p00f/nvim-ts-rainbow'}
  use {'phaazon/hop.nvim'}
  use {'numToStr/Comment.nvim'}
  use {'ur4ltz/surround.nvim'}
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
  use {'windwp/nvim-autopairs'}
  use {'lukas-reineke/indent-blankline.nvim'}
  use {'cappyzawa/trim.nvim'}
  use {'folke/todo-comments.nvim', requires = {'nvim-lua/plenary.nvim'}}
  use {'akinsho/toggleterm.nvim', tag = 'v2.*'}
  use {'norcalli/nvim-colorizer.lua'}
  use {'renerocksai/telekasten.nvim'}
  use {'ThePrimeagen/harpoon'}

  if packer_bootstrap then
    require('packer').sync()
  end
end)
