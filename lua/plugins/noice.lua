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

    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    local notify_background = normal.bg and string.format("#%06x", normal.bg) or "#000000"

    require("notify").setup({
      timeout = 750,
      background_colour = notify_background,
    })

    vim.notify = function(...)
      require("notify")(...)
    end
  end,
}
