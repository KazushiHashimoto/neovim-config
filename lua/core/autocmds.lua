-- Make nvim transparent so wezterm's background image shows through.
-- The terminal-side dim overlay (set in ~/.wezterm.lua) provides contrast.
local function clear_bg()
  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "LineNr",
    "EndOfBuffer",
    "VertSplit",
    "WinSeparator",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
    "Folded",
  }
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = "NONE", ctermbg = "NONE" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("transparent_bg", { clear = true }),
  callback = clear_bg,
})

-- Run once at startup too, since the colorscheme is set before this file is required.
clear_bg()

-- Prose filetypes: soft-wrap + display-line j/k (buffer-local)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("prose_wrap", { clear = true }),
  pattern = { "tex", "markdown", "text" },
  callback = function(args)
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true

    local map = function(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { buffer = args.buf, expr = true, silent = true })
    end
    -- count なしの素の j/k だけ表示行で動かす(5j のような count 付きは論理行のまま)
    map("j", function() return vim.v.count == 0 and "gj" or "j" end)
    map("k", function() return vim.v.count == 0 and "gk" or "k" end)
  end,
})
