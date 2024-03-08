return {
  "Shatur/neovim-ayu",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    overrides = {
      Normal = { bg = "None" },
      ColorColumn = { bg = "None" },
      SignColumn = { bg = "None" },
      Folded = { bg = "None" },
      FoldColumn = { bg = "None" },
      CursorLine = { bg = "None" },
      CursorColumn = { bg = "None" },
      WhichKeyFloat = { bg = "None" },
      VertSplit = { bg = "None" },
      NeogitDiffDeleteHighlight = { bg = "None" }
    },
  },
config = function(_, opts)
  require("ayu").setup(opts)

  vim.cmd("colorscheme ayu")
  -- vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
end,
}
