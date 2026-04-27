return {
  "romgrk/barbar.nvim",
  enabled = false,
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    animation = false,
    auto_hide = false,
    tabpages = true,
  }
}
