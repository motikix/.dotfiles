local wezterm = require('wezterm')
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.term = 'wezterm'
config.font = wezterm.font_with_fallback({ 'Moralerspace Radon HWNF', 'Noto Emoji' })
config.font_size = 16
config.harfbuzz_features = { 'calt=0' }
config.line_height = 1.4
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.75
config.enable_tab_bar = false
config.window_padding = {
  top = 0,
  right = 0,
  bottom = 0,
  left = 0,
}

return config
