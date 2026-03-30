-- Leader key (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.opt.timeoutlen = 0
vim.opt.ttimeoutlen = 0

vim.deprecate = function() end

-- Clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "git@github.com:folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins (auto-imports all lua/plugins/*.lua)
require("lazy").setup("plugins", {
  git = {
    url_format = "git@github.com:%s.git",
  },
})

-- Core modules
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Color scheme
vim.cmd.colorscheme("vscode")
