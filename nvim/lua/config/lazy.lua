-- Bootstrap Lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {import = "plugins"},
  {import = "themes.tokyonight"},
})
-- require("lazy").setup({
  -- require("themes.tokyonight"),
  -- require("plugins.treesitter"),
  -- require("plugins.telescope"),
  -- require("plugins.lualine"),
  -- require("plugins.bufferline"),
  -- require("plugins.nvimtree"),
  -- require("plugins.comment"),
  -- require("plugins.cmp"),
  -- require("plugins.lspsaga"),
-- })
