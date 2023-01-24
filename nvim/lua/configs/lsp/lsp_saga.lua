require('lspsaga').setup {
  border_style = "rounded",
  move_in_saga = { prev = '<C-p>',next = '<C-n>'},
  diagnostic_header = { " ", " ", " ", "ﴞ " },
  max_preview_lines = 10,
  code_action_icon = "💡",
  code_action_num_shortcut = true,
  code_action_lightbulb = {
      enable = true,
      sign = true,
      enable_in_insert = true,
      sign_priority = 20,
      virtual_text = true,
  },
  finder_icons = {
    def = '  ',
    ref = '諭 ',
    link = '  ',
  },
  code_action_keys = {
      quit = "q",
      exec = "<CR>",
  },
  rename_action_quit = "<C-c>",
  rename_in_select = true,
}
