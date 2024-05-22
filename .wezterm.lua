local wezterm = require("wezterm")
local act = wezterm.action

return {
  color_scheme = "SolarizedDark (Gogh)",

  font = wezterm.font_with_fallback({
    {
      family = "SauceCodePro Nerd Font",
      weight = "Regular",
      harfbuzz_features = { "zero" },
    },
    "Source Code Pro for Powerline",
  }),
  font_size = 14,

  enable_tab_bar = false,

  disable_default_key_bindings = true,
  keys = {
    { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

    { key = "m", mods = "SUPER", action = act.Hide },
    { key = "f", mods = "SUPER", action = act.ToggleFullScreen },

    { key = "=", mods = "SUPER", action = act.IncreaseFontSize },
    { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
    { key = "0", mods = "SUPER", action = act.ResetFontSize },
  },
}
