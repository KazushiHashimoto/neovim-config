return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "tokyonight",
        section_separators = "",
        component_separators = "",
      },
      winbar = {
        lualine_a = { { "filename", path = 1 } },
        lualine_b = { "diff", "diagnostics" },
        lualine_z = { "filetype" },
      },
      inactive_winbar = {
        lualine_a = { { "filename", path = 1 } },
      },
    })
  end,
}
