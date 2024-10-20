local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("options")
require("autocmds") -- TODO lazy load this

-- removed plugins when I migrated from LazyVim
--flash.nvim
--harpoon.nvim
--mason-nvim-dap.nvim
--nvim-dap  <leader>dp  <leader>dr  <leader>ds  <leader>dt  <leader>dw  <leader>d  <leader>d (v)  <leader>dB  <leader>db  <leader>dc  <leader>da  <leader>dC  <leader>dg  <leader>di  <leader>dj  <leader>dk  <leader>dl  <leader>do  <leader>dO
--nvim-dap-go  nvim-dap
--nvim-dap-python  <leader>dPt  <leader>dPc  nvim-dap
--nvim-dap-ui  <leader>du  <leader>de  <leader>de (v)  nvim-dap
--nvim-dap-virtual-text  nvim-dap
--nvim-nio
--nvim-treesitter-textobjects

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "lang" }, -- TODO: remove lazy extras
    { import = "pinned" },
  },
  defaults = {
    lazy = true,
    version = "*",
  },
  ui = { border = "rounded" },
  checker = { enabled = false }, -- disable check for updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

if vim.g.vscode then
  require("vscode")
else
  require("keymaps").maps()
end
