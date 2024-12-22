return {
  {
    "robitx/gp.nvim",
    event = "VeryLazy",
    opts = {
      cmd_prefix = "A",
      default_chat_agent = "CodeClaude-3-5-Sonnet",
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
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.popup, agent, template)
        end,
        CodeReview = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please analyze for code smells and suggest improvements."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.vnew("markdown"), agent, template)
        end,
        Document = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please analyze the code and generate a valid documentation for it according to the code language."
            .. "Please RETURN ONLY the documentation as the response."
          	.. "START AND END YOUR ANSWER WITH:\n\n```"
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.prepend, agent, template)
        end,
        English = function(gp, params)
          local template = "I have the following text:\n\n"
            .. "{{selection}}\n\n"
            .. "Please correct the text above to standard english. Respond exclusively with the text that should replace the text above."
          local agent = gp.get_chat_agent("ChatGPT4o")
          gp.Prompt(params, gp.Target.rewrite, agent, template)
        end,
      },
    },
  },
}
