return {
  "folke/tokyonight.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    style = "night",
    transparent = true,
    terminal_colors = true,
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = true },
        variables = { italic = true },
    },
    on_colors = function(colors)
      colors.bg = "None"
      colors.bg_sidebar = "None"
      colors.bg_dark = "None"
      colors.bg_float = "None"
      colors.bg_statusline = "None"
   end,
  },
config = function(_, opts)
  require("tokyonight").setup(opts)

  vim.cmd([[colorscheme tokyonight]])
end,
}
