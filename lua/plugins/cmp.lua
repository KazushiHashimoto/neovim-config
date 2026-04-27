return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      enabled = function()
        local col = vim.fn.col(".") - 1
        if col <= 0 then
          return true
        end
        local line = vim.fn.getline(".")
        local before = line:sub(1, col)
        if before:match("::%s*&") then
          return false
        end
        return true
      end,

      completion = {
        autocomplete = false,
        keyword_length = 2,
      },

      mapping = cmp.mapping.preset.insert({
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<Up>"] = cmp.mapping.select_prev_item(),
["<Esc>"] = cmp.mapping.abort(),
        ["<C-p>"] = cmp.mapping.complete(),
      }),

      sources = {
        { name = "nvim_lsp", max_item_count = 15 },
        { name = "path" },
        { name = "buffer", max_item_count = 5, keyword_length = 3 },
      },

      experimental = {
        ghost_text = true,
      },
    })
  end,
}
