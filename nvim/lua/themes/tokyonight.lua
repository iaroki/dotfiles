return {
  "folke/tokyonight.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    style = "night",
    transparent = false,
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = true },
        variables = { italic = true },
    },
    on_colors = function(colors)
      colors.bg = "#000000"
      colors.bg_sidebar = "#000000"
      colors.bg_dark = "#000000"
      colors.bg_float = "#000000"
      colors.bg_highlight = "#000000"
      colors.bg_popup = "#000000"
      colors.bg_search = "#000000"
      colors.bg_statusline = "#000000"
      colors.bg_visual = "#222222"
   end,
  },
config = function(_, opts)
  require("tokyonight").setup(opts)

  vim.cmd([[colorscheme tokyonight]])
end,
}

