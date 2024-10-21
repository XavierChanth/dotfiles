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
-- - dap & testing stuff

require("options")
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.lang" },
    { import = "plugins.lang-after" },
    { import = "plugins.after" },
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
