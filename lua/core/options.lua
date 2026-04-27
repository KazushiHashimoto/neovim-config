vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.scrolloff = 8

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.cmdheight = 1
vim.opt.laststatus = 3

-- Hide the ~ marker on empty lines past end-of-buffer
vim.opt.fillchars:append({ eob = " " })

vim.cmd("syntax on")

