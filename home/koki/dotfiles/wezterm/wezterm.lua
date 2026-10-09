local wezterm = require 'wezterm'
local config = wezterm.config_builder()

------------------------------------------------------------
-- General Settings
------------------------------------------------------------
config.automatically_reload_config = true
config.font_size = 14.0
config.use_ime = true

config.window_background_opacity = 0.6
config.macos_window_background_blur = 16
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = false

config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

config.window_background_gradient = {
  colors = {
    '#0f0c29',
    '#302b63',
    '#24243e',
  },
}

config.window_padding = {
  left = 6,
  right = 6,
  top = 6,
  bottom = 6,
}

config.show_new_tab_button_in_tab_bar = false

config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

------------------------------------------------------------
-- Blur Toggle
------------------------------------------------------------
local blur_enabled = true

local function toggle_blur(window, _)
  blur_enabled = not blur_enabled

  window:set_config_overrides({
    window_background_opacity = 0.6,
    wayland_window_background_blur = blur_enabled and 16 or 0,
  })
end

config.keys = {
  {
    key = "B",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(toggle_blur),
  },
}

------------------------------------------------------------
-- Tab Title Formatting
------------------------------------------------------------
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
  local is_active = tab.is_active

  local background = is_active and "#191960" or "#191919"
  local foreground = is_active and "#CCCCFF" or "#797979"
  local edge_background = "none"
  local edge_foreground = background

  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },

    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },

    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

return config

