-- File tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>o", ":NvimTreeFindFile<CR>")

-- Terminal mode escape (but not in lazygit)
vim.keymap.set("t", "<Esc>", function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  if buf_name:match("lazygit") then
    return "<Esc>"
  end
  return [[<C-\><C-n>]]
end, { expr = true })

-- Buffer navigation
vim.keymap.set("n", "<S-l>", ":bprevious<CR>")
vim.keymap.set("n", "<S-h>", ":bnext<CR>")

vim.keymap.set("n", "<leader>bd", ":bdelete<CR>")

vim.keymap.set("n", "<leader>bp", ":BufferPick<CR>")

-- Build
vim.keymap.set("n", "<leader>m", ":Make<CR>")

-- Paste over selection without clobbering the yank register
vim.keymap.set("x", "<C-p>", [["_dP]])
