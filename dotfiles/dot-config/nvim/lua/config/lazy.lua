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
-- removed plugins when I migrated from LazyVim
-- - flash.nvim
-- - harpoon.nvim
-- - mason-nvim-dap.nvim
-- - nvim-dap
-- - nvim-dap-go
-- - nvim-dap-python
-- - nvim-dap-ui
-- - nvim-dap-virtual-text
-- - nvim-nio
-- - nvim-treesitter-textobjects

require("config.options")
require("lazy").setup({
  spec = {
    { import = "config.autocmds" },
    { import = "plugins" },
    { import = "plugins.lang" },
    { import = "config.vscode" },
    { import = "config.keymaps" },
    { import = "config.pinned" },
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
