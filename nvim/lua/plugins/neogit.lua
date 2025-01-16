return {
  "TimUntersberger/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim"
  },
  opts = {
    disable_signs = false,
    disable_hint = false,
    disable_context_highlighting = false,
    disable_insert_on_commit = true,
    disable_commit_confirmation = true,
    auto_refresh = true,
    graph_style = "unicode",
    sort_branches = "-committerdate",
    disable_builtin_notifications = false,
    use_magit_keybindings = false,
    kind = "tab",
    console_timeout = 2000,
    auto_show_console = true,
    remember_settings = true,
    use_per_project_settings = true,
    highlight = {
      italic = true,
      bold = true,
      underline = true
    },
    -- commit_editor = {
    --   kind = "floating",
    --   staged_diff_split_kind = "floating",
    -- },
    -- preview_buffer = {
    --   kind = "split",
    -- },
    -- popup = {
    --   kind = "floating",
    -- },
    signs = {
      -- { CLOSED, OPENED }
      section = { ">", "v" },
      item = { ">", "v" },
      hunk = { "", "" },
    },
    integrations = {
      diffview = true
    },
  },
}
