-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.term = 'wezterm'
config.initial_cols = 120
config.initial_rows = 28

config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.line_height = 1.15
config.font_size = 14
config.color_scheme = 'Dark+'

-- Unified title bar with tabs
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'

config.keys = {
  -- Tabs
  { key = 't', mods = 'CTRL', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL', action = wezterm.action.CloseCurrentTab { confirm = true } },
  { key = 'n', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'p', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(-1) },
  
  -- Panes (splits)
  { key = 's', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- Navigate panes with CTRL+hjkl (vim-style)
  { key = 'h', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Right' },

  -- Close pane
  { key = 'x', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentPane { confirm = true } },

  -- New window
  { key = 'n', mods = 'CTRL|ALT', action = wezterm.action.SpawnWindow },
}

-- Finally, return the configuration to wezterm:
return config
