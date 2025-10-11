return {
  {
    "williamboman/mason.nvim", -- manage LSP servers, DAP servers, linters, and formatters through a single interface
    lazy = false,
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim", -- install LSP servers
    lazy = false,
    opts = {
      automatic_installation = true,
      ensure_installed = { "lua_ls", "ts_ls", "eslint", "html", "tailwindcss", "ansiblels", "ruby_lsp" },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim", -- install formatters & linters
    lazy = false,
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "rubocop", -- ruby formatter
      },
    },
  },
  {
    "neovim/nvim-lspconfig", -- configure LSP servers
    lazy = false,
    config = function()
      local opts = { noremap = true, silent = true }

      vim.lsp.commands["rubyLsp.openFile"] = function(command)
        local arguments = command.arguments[1]
        local uri = arguments[1]
        local line = arguments[2] or 0

        -- Convert LSP URI to file path
        local filepath = vim.uri_to_fname(uri)

        -- Open the file
        vim.cmd("edit " .. filepath)

        -- Move to specified line
        if line > 0 then
          vim.api.nvim_win_set_cursor(0, {line, 0})
        end
      end

      vim.lsp.commands["rubyLsp.runTest"] = function()
        require("neotest").run.run()
      end

      vim.lsp.commands["rubyLsp.runTestInTerminal"] = function()
        local neotest = require("neotest")
        neotest.output_panel.clear()
        neotest.run.run()
        neotest.output_panel.open()
      end

      vim.lsp.commands["rubyLsp.debugTest"] = function()
        local neotest = require("neotest")
        neotest.output_panel.clear()
        neotest.run.run({ strategy = "tmux" })
      end

      local on_attach = function(client, bufnr)
        opts.buffer = bufnr
        vim.lsp.inlay_hint.enable()

        -- Enable CodeLens
        if client.server_capabilities.codeLensProvider then
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = function()
              vim.lsp.codelens.refresh()
            end,
          })
          -- Initial refresh
          vim.lsp.codelens.refresh()
        end

        -- Add key mappings for CodeLens actions
        opts.desc = "Run CodeLens action"
        vim.keymap.set('n', '<leader>c', vim.lsp.codelens.run, opts)

        -- opts.desc = "Show documentation for what is under cursor"
        -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- opts.desc = "Show line diagnostics"
        -- vim.keymap.set("n", "<C-W>d", vim.diagnostic.open_float, opts)

        -- opts.desc = "Go to previous diagnostic"
        -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        -- opts.desc = "Go to next diagnostic"
        -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Go to definition"
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        -- Default keymaps: https://neovim.io/doc/user/lsp.html#_global-defaults
        -- "grn" is mapped in Normal mode to rename all references to the symbol under the cursor (vim.lsp.buf.rename)
        -- "gra" is mapped in Normal and Visual mode to select code action available at the current cursor position (vim.lsp.buf.code_action)
        -- "grr" is mapped in Normal mode to list all the references to the symbol under the cursor in the quickfix window (vim.lsp.buf.references)
        -- "gri" is mapped in Normal mode to list all the implementations for the symbol under the cursor in the quickfix window (vim.lsp.buf.implementation)
        -- "gO" is mapped in Normal mode to list all symbols in the current buffer in the location-list (vim.lsp.buf.document_symbol)
        -- CTRL-S is mapped in Insert mode to show signature information about the symbol under the cursor in a floating window (vim.lsp.buf.signature_help)

        opts.desc = "Show available code actions"
        vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)

        opts.desc = "Format source code"
        vim.keymap.set("n", "F", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local border = {
        { "┌", "FloatBorder" },
        { "─", "FloatBorder" },
        { "┐", "FloatBorder" },
        { "│", "FloatBorder" },
        { "┘", "FloatBorder" },
        { "─", "FloatBorder" },
        { "└", "FloatBorder" },
        { "│", "FloatBorder" },
      }

      -- setup borders in the diagnostic window.
      vim.diagnostic.config({
        float = {
          border = border,
        },
      })

      -- only show diagnostics in the current line
      vim.diagnostic.config({ virtual_text = { current_line = true } })

      -- add the border on hover and on signature help popup window
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      }

      -- change the Diagnostic symbols in the sign column (gutter)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local lsps = {"lua_ls", "ts_ls", "html", "tailwindcss", "ansiblels", "ruby_lsp"}
      for _, lsp in pairs(lsps) do
        vim.lsp.config(lsp, {
          capabilities = capabilities,
          on_attach = on_attach,
          handlers = handlers,
        })
      end
    end,

    vim.keymap.set("n", "<leader>d", function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, { desc = "Toggle diagnostics" })
  },
  {
    "nvimtools/none-ls.nvim", -- configure formatters & linters
    dependencies = {
      "davidmh/cspell.nvim",
    },
    lazy = false,
    config = function()
      local null_ls = require("null-ls")
      local null_ls_utils = require("null-ls.utils")
      local cspell = require('cspell')

      local formatting = null_ls.builtins.formatting -- to setup formatters
      local diagnostics = null_ls.builtins.diagnostics -- to setup linters
      local hover = null_ls.builtins.hover -- to setup hovers

      null_ls.setup({
        root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
        sources = {
          formatting.stylua,
          formatting.prettier,
          formatting.rubocop,
          diagnostics.rubocop,
          diagnostics.ltrs,
          cspell.diagnostics,
          cspell.code_actions,
          hover.printenv,
        },
      })
    end,
  },
}
