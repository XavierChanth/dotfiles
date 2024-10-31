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
    { import = "plugins.tui", cond = not Util.platform.is_gui() },
    { import = "plugins.lang", cond = not Util.platform.supports_lsp() },
    { import = "plugins.langs", cond = Util.platform.supports_lsp() },
    { import = "plugins.last" },
  },
  checker = { enabled = false }, -- disable check for updates
  change_detection = { enabled = false },
  defaults = {
    lazy = true,
    version = "*",
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
