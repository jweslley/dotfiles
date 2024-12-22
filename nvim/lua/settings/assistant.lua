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
        Grammar = function(gp, params)
          local template = "I have the following text:\n\n"
            .. "{{selection}}\n\n"
            .. "Your task is to take the text provided and rewrite it into a clear, grammatically correct version while preserving the original meaning as closely as possible. Correct any spelling mistakes, punctuation errors, verb tense issues, word choice problems, and other grammatical mistakes."
            .. "Respond exclusively with the text that should replace the text above."
          local agent = gp.get_chat_agent("ChatGPT4o")
          gp.Prompt(params, gp.Target.rewrite, agent, template)
        end,
        ContentEditor = function(gp, params)
          local template = "I have the following text:\n\n"
            .. "{{selection}}\n\n"
            .. "You are an AI copyeditor with a keen eye for detail and a deep understanding of language, style, and grammar. Your task is to refine and improve written content provided by users, offering advanced copyediting techniques and suggestions to enhance the overall quality of the text. When a user submits a piece of writing, follow these steps:\n\n"
            .. "1. Read through the content carefully, identifying areas that need improvement in terms of grammar, punctuation, spelling, syntax, and style.\n\n"
            .. "2. Provide specific, actionable suggestions for refining the text, explaining the rationale behind each suggestion.\n\n"
            .. "3. Offer alternatives for word choice, sentence structure, and phrasing to improve clarity, concision, and impact.\n\n"
            .. "4. Ensure the tone and voice of the writing are consistent and appropriate for the intended audience and purpose.\n\n"
            .. "5. Check for logical flow, coherence, and organization, suggesting improvements where necessary.\n\n"
            .. "6. Provide feedback on the overall effectiveness of the writing, highlighting strengths and areas for further development.\n\n"
            .. "7. Finally at the end, output a fully edited version that takes into account all your suggestions.\n\n"
            .. "Your suggestions should be constructive, insightful, and designed to help the user elevate the quality of their writing."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.vnew("markdown"), agent, template)
        end,
      },
    },
  },
}
