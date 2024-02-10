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

  quick_select_patterns = {
    -- TODO: add pattern to match filename:filenumber
    -- r"(?:[.\w\-@~]+)?(?:/[.\w\-@]+)+",
  },

  disable_default_key_bindings = true,
  keys = {
    { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

    { key = "m", mods = "SUPER", action = act.Hide },
    { key = "f", mods = "SUPER", action = act.ToggleFullScreen },

    { key = "=", mods = "SUPER", action = act.IncreaseFontSize },
    { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
    { key = "0", mods = "SUPER", action = act.ResetFontSize },

    { key = "[", mods = "SUPER", action = act.ScrollByPage(-1) },
    { key = "]", mods = "SUPER", action = act.ScrollByPage(1) },
    { key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackOnly") },

    { key = "/", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "s", mods = "SUPER", action = act.QuickSelect },
    { key = "x", mods = "SUPER", action = act.ActivateCopyMode },
  },

  key_tables = {
    search_mode = {
      { key = "Escape",   mods = "NONE", action = act.CopyMode("Close") },

      { key = "j",        mods = "CTRL", action = act.CopyMode("NextMatch") },
      { key = "k",        mods = "CTRL", action = act.CopyMode("PriorMatch") },

      { key = "h",        mods = "CTRL", action = act.CopyMode("CycleMatchType") },
      { key = "l",        mods = "CTRL", action = act.CopyMode("ClearPattern") },

      { key = "PageUp",   mods = "NONE", action = act.CopyMode("PriorMatchPage") },
      { key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
    },
  },
}
