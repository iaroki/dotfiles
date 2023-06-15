return {
    "nvim-telescope/telescope.nvim",
    -- cmd = "Telescope find_files",
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
      extensions = {
        "git_worktree",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  }
