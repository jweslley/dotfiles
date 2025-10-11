return {
  "nvim-neotest/neotest",
  event = "BufEnter *_spec.rb",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-rspec",
  },
  config = function()
    local neotest = require("neotest")
    local rspec = require("neotest-rspec")

    neotest.setup({
      adapters = {
        rspec({
          rspec_cmd = function()
            return vim.tbl_flatten({
              "docker",
              "compose",
              "exec",
              "-i",
              "spring",
              "./bin/rspec",
            })
          end,

          transform_spec_path = function(path)
            local prefix = rspec.root(path)
            return string.sub(path, string.len(prefix) + 2, -1)
          end,

          results_path = "tmp/rspec.output",

          formatter = "json",
        }),
      },
    })

    vim.keymap.set("n", "<leader>ts", ":Neotest summary<CR>", { desc = "Show structure of the test suite" })

    vim.keymap.set("n", "<leader>tw", function()
      neotest.watch.toggle()
    end, { desc = "Toggle watching a position and run it whenever related files are changed" })

    vim.keymap.set("n", "T", function()
      neotest.output_panel.clear()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "Run the current file" })

    vim.keymap.set("n", "t", function()
      neotest.output_panel.clear()
      neotest.run.run()
    end, { desc = "Run the nearest test" })

    vim.keymap.set("n", "<leader>tl", function()
      neotest.output_panel.clear()
      neotest.run.run_last()
    end, { desc = "Re-run the last test" })

    vim.keymap.set("n", "<leader>to", function()
      neotest.output_panel.toggle()
    end, { desc = "Toggle the output panel" })
  end,
}
