-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true

vim.opt.colorcolumn = "81,121"
vim.opt.ttimeout = false

vim.opt.listchars = {
  -- eol = "↓",
  tab = "  ┊",
  trail = "●",
  extends = "…",
  precedes = "…",
  space = "·",
}
