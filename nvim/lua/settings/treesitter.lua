return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  opts = {
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    autotag = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "zz",
        node_incremental = "zz",
        node_decremental = "<bs>",
        scope_incremental = false,
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,

        keymaps = {
          ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
          ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
          ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
          ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

          ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
          ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

          ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
          ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

          ["am"] = { query = "@function.outer", desc = "Select outer part of a function/method def" },
          ["im"] = { query = "@function.inner", desc = "Select inner part of a function/method def" },

          ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
          ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

          ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
        },

        selection_modes = {
          ["@function.outer"] = "V", -- linewise
          ["@function.inner"] = "V", -- linewise
          ["@class.outer"] = "V", -- linewise
          ["@class.inner"] = "V", -- linewise
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>na"] = "@parameter.inner", -- swap parameter/argument with next
          ["<leader>nm"] = "@function.outer", -- swap function with next
        },
        swap_previous = {
          ["<leader>pa"] = "@parameter.inner", -- swap parameter/argument with prev
          ["<leader>pm"] = "@function.outer", -- swap function with prev
        },
      },
      move = {
        enable = true,
        set_jumps = true,

        goto_next_start = {
          ["]f"] = { query = "@call.outer", desc = "Next function call start" },
          ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
          ["]c"] = { query = "@class.outer", desc = "Next class start" },
        },

        goto_next_end = {
          ["]F"] = { query = "@call.outer", desc = "Next function call end" },
          ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
          ["]C"] = { query = "@class.outer", desc = "Next class end" },
        },

        goto_previous_start = {
          ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
          ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
          ["[c"] = { query = "@class.outer", desc = "Prev class start" },
        },

        goto_previous_end = {
          ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
          ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
          ["[C"] = { query = "@class.outer", desc = "Prev class end" },
        },
      },
    },
  },
  init = function()
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- repeat movement with ; and ,
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    -- make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
  end,
}
