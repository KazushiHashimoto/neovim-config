return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      cmdline = {
        view = "cmdline_popup",
        opts = {
          position = { row = "100%", col = "50%" },
          size = { width = 60 },
        },
      },
      views = {
        cmdline_popup = {
          position = { row = "100%", col = "50%" },
          size = { width = 60 },
        },
        cmdline_popupmenu = {
          position = { row = "90%", col = "50%" },
          size = { width = 60, height = "auto" },
        },
      },
      presets = {
        command_palette = false,
        bottom_search = true,
      },
      lsp = {
        progress = {
          enabled = false,
        },
      },
    })

    require("notify").setup({
      timeout = 750,
    })

    vim.notify = function(...)
      require("notify")(...)
    end
  end,
}
