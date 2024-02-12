return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          path_display = { "truncate" },
          mappings = {
            i = {
              ["<C-k>"] = require("telescope.actions").move_selection_previous, -- move to prev result
              ["<C-j>"] = require("telescope.actions").move_selection_next, -- move to next result
              ["<C-q>"] = require("telescope.actions").send_selected_to_qflist
                  + require("telescope.actions").open_qflist,
            },
          },
          extensions = {
            ["ui-select"] = {
              require("telescope.themes").get_dropdown({}),
            },
          },
        },
      })

      local opts = {}

      opts.desc = "Lists files in current directory"
      vim.keymap.set("n", "<leader>o", "<cmd>Telescope find_files<CR>", opts)

      opts.desc = "Lists open buffers"
      vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)

      opts.desc = "Search for a string in current directory"
      vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<CR>", opts)

      opts.desc = "Lists all symbols in current buffer"
      vim.keymap.set("n", "<leader>l", "<cmd>Telescope treesitter<CR>", opts)

      require("telescope").load_extension("ui-select")
    end,
  },
}
