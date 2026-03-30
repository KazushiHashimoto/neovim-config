return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
  },
  {
    "chriskempson/vim-tomorrow-theme",
    lazy = true,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
  },
  {
    "webhooked/kanso.nvim",
    lazy = true,
  },
  {
    "smit4k/shale.nvim",
    lazy = true,
  },
  {
    "p00f/alabaster.nvim",
    lazy = true,
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    config = function()
      require("vscode").setup({
        group_overrides = {
          Normal = { bg = "#1D1F21" },
          NormalNC = { bg = "#1D1F21" },
        },
      })
    end,
  },
}
