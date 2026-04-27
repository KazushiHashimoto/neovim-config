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
