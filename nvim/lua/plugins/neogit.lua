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
    commit_popup = {
      kind = "split",
    },
    preview_buffer = {
      kind = "split",
    },
    popup = {
      kind = "split",
    },
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
