return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "bashls",
          "clangd",
        },
        automatic_enable = false,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(client, bufnr)
        if client.server_capabilities.signatureHelpProvider then
          client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
        end

        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gd",         vim.lsp.buf.definition,      opts)
        vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,     opts)
        vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,  opts)
        vim.keymap.set("n", "gr",         vim.lsp.buf.references,      opts)
        vim.keymap.set("n", "K",          vim.lsp.buf.hover,           opts)
        vim.keymap.set({ "n", "i" }, "<M-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,          opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,     opts)
        vim.keymap.set("n", "<leader>D",  vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,    opts)
        vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,    opts)
      end

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.bashls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = lspconfig.util.root_pattern(
          "compile_commands.json",
          ".git"
        ),
      })
    end,
  },
}
