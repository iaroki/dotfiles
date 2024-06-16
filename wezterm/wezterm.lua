-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
config.default_gui_startup_args = { 'start', '--always-new-process' }

-- Multiplexing
local mux = wezterm.mux

-- Changing the color scheme:
local scheme = wezterm.get_builtin_color_schemes()['tokyonight_night']
scheme.background = 'black'
scheme.ansi = {"#15161e", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#f5c2e7", "#cba6f7", "#a9b1d6"}
scheme.brights = {"#414868", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#f5c2e7", "#cba6f7", "#c0caf5"}
config.color_schemes = {
  ['tokyonight_black'] = scheme,
}

config.color_scheme = 'tokyonight_black'

-- Appearance tweaks
config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 12
config.enable_tab_bar = false
config.window_background_opacity = 0.95
config.window_decorations = "NONE"
config.window_padding = {
  left   = 5,
  right  = 5,
  top    = 5,
  bottom = 5,
}

config.window_frame = {
  border_left_width    = 0,
  border_right_width   = 0,
  border_bottom_height = 0,
  border_top_height    = 0,
  border_left_color    = '#cba6f7',
  border_right_color   = '#cba6f7',
  border_bottom_color  = '#cba6f7',
  border_top_color     = '#cba6f7',
}

-- Maximized windows

wezterm.on('gui-attached', function(domain)
  -- maximize all displayed windows on startup
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end)

-- Wayland crash workaround
config.enable_wayland = false

-- and finally, return the configuration to wezterm
return config
