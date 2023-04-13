local custom_gruvbox = require'lualine.themes.gruvbox'
custom_gruvbox.normal.c.bg = '#111111'
custom_gruvbox.insert.c.bg = '#111111'
custom_gruvbox.visual.c.bg = '#111111'
custom_gruvbox.replace.c.bg = '#111111'
custom_gruvbox.command.c.bg = '#111111'
custom_gruvbox.inactive.c.bg = '#111111'

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = custom_gruvbox,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
