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
      ensure_installed = { "lua_ls", "solargraph", "tsserver", "eslint", "html", "tailwindcss" },
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
        "eslint_d", -- js linter
        "rubocop", -- ruby formatter
      },
    },
  },
  {
    "neovim/nvim-lspconfig", -- configure LSP servers
    lazy = false,
    config = function()
      local opts = { noremap = true, silent = true }

      local on_attach = function(client, bufnr)
        opts.buffer = bufnr

        opts.desc = "Show documentation for what is under cursor"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Go to definition"
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        opts.desc = "Show all references"
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        opts.desc = "Show available code actions"
        vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show line diagnostics"
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

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

      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = handlers,
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = handlers,
      })
      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = handlers,
      })
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = handlers,
      })
      lspconfig.solargraph.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        handlers = handlers,
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim", -- configure formatters & linters
    lazy = false,
    config = function()
      local null_ls = require("null-ls")
      local null_ls_utils = require("null-ls.utils")

      local formatting = null_ls.builtins.formatting -- to setup formatters
      local diagnostics = null_ls.builtins.diagnostics -- to setup linters

      null_ls.setup({
        root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
        sources = {
          formatting.stylua,
          formatting.prettier,
          formatting.rubocop,
          diagnostics.rubocop,
          diagnostics.eslint_d.with({
            condition = function(utils)
              return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
            end,
          }),
        },
      })
    end,
  },
}
