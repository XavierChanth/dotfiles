-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smarttab = true

opt.colorcolumn = "81,121"
opt.ttimeout = false

opt.listchars = {
  -- eol = "↓",
  tab = "  ┊",
  trail = "●",
  extends = "…",
  precedes = "…",
  space = "·",
}

-- Reset the clipboard to default
opt.clipboard = ""
