return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    predefined_chat_gpt_prompts = "file://" .. debug.getinfo(1).short_src:gsub(".lua$", "/prompts.csv"),
    edit_with_instructions = {
      diff = false,
      keymaps = {
        close = "<C-q>",
      },
    },
    chat = {
      question_sign = "",
      answer_sign = "󰚩",
      keymaps = {
        close = "<C-q>",
        scroll_up = "<C-[>",
        scroll_down = "<C-]>",
        next_message = "<C-J>",
        prev_message = "<C-K>",
      },
    },
    popup_input = {
      prompt = "> ",
    },
  },
  init = function()
    local act_as = function(ft, act, prompt)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        callback = function()
          vim.keymap.set("n", "<leader>cp", function()
            local Session = require("chatgpt.flows.chat.session")
            local Chat = require("chatgpt.flows.chat.base")

            local session = Session.new({ name = act })
            session:save()

            local chat = Chat:new()
            chat:open()
            chat.chat_window.border:set_text("top", " ChatGPT - Acts as " .. act .. " ", "center")

            chat:set_system_message(prompt)
            chat:open_system_panel()
          end, { buffer = true, desc = "Acts as " .. act })
        end,
      })
    end

    act_as(
      "ruby",
      "Ruby Developer",
      "I want you to act as a senior ruby on rails software developer. I will provide some specific information about a web app requirements, and it will be your job to come up with an architecture and code for developing secure app with Ruby on Rails."
    )

    act_as(
      { "typescriptreact", "typescript" },
      "Frontend Developer",
      "I want you to act as a Senior Frontend developer. I will describe a project details you will code project with this tools: react, yarn, tailwindcss, typescript, react-table, react-query, react-router-dom. You should merge files in single index.js file and nothing else. Do not write explanations."
    )
  end,
  keys = {
    { "<leader>cc", "<cmd>ChatGPT<cr>",                       desc = "ChatGPT" },
    { "<leader>cP", "<cmd>ChatGPTActAs<cr>",                  desc = "Acts as ..." },
    { "<leader>ce", "<cmd>ChatGPTEditWithInstruction<cr>",    desc = "Edit with instruction", mode = { "n", "v" } },
    { "<leader>cg", "<cmd>ChatGPTRun grammar_correction<cr>", desc = "Grammar correction",    mode = { "n", "v" } },
    { "<leader>ct", "<cmd>ChatGPTRun translate<cr>",          desc = "Translate",             mode = { "n", "v" } },
    { "<leader>ck", "<cmd>ChatGPTRun keywords<cr>",           desc = "Keywords",              mode = { "n", "v" } },
    { "<leader>cd", "<cmd>ChatGPTRun docstring<cr>",          desc = "Docstring",             mode = { "n", "v" } },
    { "<leader>ca", "<cmd>ChatGPTRun add_tests<cr>",          desc = "Add tests",             mode = { "n", "v" } },
    { "<leader>co", "<cmd>ChatGPTRun optimize_code<cr>",      desc = "Optimize code",         mode = { "n", "v" } },
    { "<leader>cs", "<cmd>ChatGPTRun summarize<cr>",          desc = "Summarize",             mode = { "n", "v" } },
    { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<cr>",           desc = "Fix bugs",              mode = { "n", "v" } },
    { "<leader>cx", "<cmd>ChatGPTRun explain_code<cr>",       desc = "Explain code",          mode = { "n", "v" } },
    {
      "<leader>cr",
      "<cmd>ChatGPTRun code_readability_analysis<cr>",
      desc = "Code readability analysis",
      mode = { "n", "v" },
    },
  },
}
