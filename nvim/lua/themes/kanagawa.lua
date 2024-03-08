return {
  "rebelot/kanagawa.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    compile = false,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = true,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    colors = {                   -- add/modify theme and palette colors
        palette = {},
        theme = {
          wave = {},
          lotus = {},
          dragon = {},
          all = {
            ui = {
              bg_gutter = "none"
            }
          }
        },
    },
    overrides = function(colors) -- add/modify highlights
      local theme = colors.theme
      return {
        TelescopeBorder = { bg = "none" },
      }
    end,
    theme = "wave",            -- Load "wave" theme when 'background' option is not set
    background = {               -- map the value of 'background' option to a theme
        dark = "wave",         -- try "dragon" !
        light = "lotus"
    },
  },
config = function(_, opts)
  require("kanagawa").setup(opts)

  vim.cmd("colorscheme kanagawa")
  -- vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
end,
}
