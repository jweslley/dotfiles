return {
  { "wsdjeg/vim-fetch" },     -- open file in specific file number and column
  { "tpope/vim-rails" },      -- rails
  {
    "echasnovski/mini.pairs", -- automatically manage character pairs
    event = "VeryLazy",
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    keys = {
      { "-",  "<cmd>Oil<cr>" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "echasnovski/mini.surround", -- surround actions
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "sa",            -- Add surrounding in Normal and Visual modes
        delete = "sd",         -- Delete surrounding
        find = "sf",           -- Find surrounding (to the right)
        find_left = "sF",      -- Find surrounding (to the left)
        highlight = "sh",      -- Highlight surrounding
        replace = "sr",        -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`

        suffix_last = "l",     -- Suffix to search with "prev" method
        suffix_next = "n",     -- Suffix to search with "next" method
      },
    },
  },
  {
    "echasnovski/mini.comment", -- manage comments
    event = "VeryLazy",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
      mappings = {
        comment = "gc",        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        comment_line = "gcc",  -- Toggle comment on current line
        comment_visual = "gc", -- Toggle comment on visual selection
        textobject = "gc",     -- Define 'comment' textobject (like `dgc` - delete whole comment block)
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
}
