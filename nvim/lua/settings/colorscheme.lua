return {
  "maxmx03/solarized.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("solarized").setup({ theme = "neo" })

    vim.o.background = "dark"

    vim.cmd.colorscheme("solarized")
  end,
}
