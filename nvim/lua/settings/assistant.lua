return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "claude",
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-20240620",
        temperature = 0,
        max_tokens = 4096,
      },
      mappings = {
        ask = "<leader>ca",
        edit = "<leader>ce",
        refresh = "<leader>cr",
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
    },
  },
  {
    "robitx/gp.nvim",
    event = "VeryLazy",
    opts = {
      cmd_prefix = "A",
      default_chat_agent = "ChatGPT4o",
      default_command_agent = "CodeClaude-3-5-Sonnet",
      providers = {
        openai = {
          disable = false,
        },
        anthropic = {
          disable = false,
        },
      },
      hooks = {
        Implement = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please rewrite this according to the contained instructions."
            .. "\n\nRespond exclusively with the snippet that should replace the selection above."

          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.rewrite, agent, template)
        end,
        Tests = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by writing tests for the code above."
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
        Explain = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by explaining the code above."
          local agent = gp.get_chat_agent("ChatClaude-3-5-Sonnet")
          gp.Prompt(params, gp.Target.popup, agent, template)
        end,
        CodeReview = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please analyze for code smells and suggest improvements."
          local agent = gp.get_chat_agent("ChatClaude-3-5-Sonnet")
          gp.Prompt(params, gp.Target.vnew("markdown"), agent, template)
        end,
        English = function(gp, params)
          local template = "I have the following text:\n\n"
            .. "{{selection}}\n\n"
            .. "Please correct the text above to standard english. Respond exclusively with the text that should replace the text above."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.rewrite, agent, template)
        end,
      },
    },
  },
}
