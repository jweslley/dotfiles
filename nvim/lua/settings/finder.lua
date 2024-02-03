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
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      vim.keymap.set("n", "<leader>o", "<cmd>Telescope find_files theme=ivy<CR>", { desc = "Lists files in current directory" })
      vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers theme=ivy<CR>", { desc = "Lists open buffers" })
      vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep theme=ivy<CR>", { desc = "Search for a string in current directory" })
      vim.keymap.set("n", "<leader>l", "<cmd>Telescope current_buffer_tags theme=ivy<CR>", { desc = "Lists all of the tags for the current buffer" })

      require("telescope").load_extension("ui-select")
    end,
  },
}
