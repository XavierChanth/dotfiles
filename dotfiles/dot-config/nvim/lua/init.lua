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
require("lazy").setup({
  spec = {
    { import = "plugins.core" },
    { import = "plugins.tui", cond = not vim.g.vscode },
    { import = "plugins.lang", cond = not vim.g.vscode },
    { import = "plugins.langs", cond = not vim.g.vscode },
    { import = "plugins.last" },
  },
  checker = { enabled = false }, -- disable check for updates
  change_detection = { enabled = false },
  defaults = {
    lazy = true,
    version = "*",
  },
  install = {
    -- colorscheme = { require("last-color").recall() },
  },
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
  ui = {
    border = "rounded",
    size = { width = 0.85, height = 0.85 },
  },
})
