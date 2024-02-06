return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local colors = require("solarized.palette").get_colors()

    local theme = {
      normal = {
        a = { fg = colors.blue, bg = colors.base02 },
        b = { fg = colors.base01, bg = colors.base02 },
        c = { fg = colors.base1, bg = colors.base02 },
        x = { fg = colors.base01, bg = colors.base02 },
        y = { fg = colors.base01, bg = colors.base02 },
        z = { fg = colors.base01, bg = colors.base02 },
      },
      insert = {
        a = { fg = colors.green, bg = colors.base02 },
      },
      visual = {
        a = { fg = colors.magenta, bg = colors.base02 },
      },
      replace = {
        a = { fg = colors.red, bg = colors.base02 },
      },
      command = {
        a = { fg = colors.orange, bg = colors.base02 },
      },
    }

    require("lualine").setup({
      options = {
        theme = theme,
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "%c:%l/%L" },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
