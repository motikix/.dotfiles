local wezterm = require('wezterm')

return {
  term = 'wezterm',
  font = wezterm.font_with_fallback({ 'Moralerspace Radon HWNF', 'Noto Emoji' }),
  font_size = 16,
  harfbuzz_features = { 'calt=0' },
  color_scheme = 'Catppuccin Mocha',
  enable_tab_bar = false,
  window_padding = {
    top = 0,
    right = 0,
    bottom = 0,
    left = 0,
  },
}
