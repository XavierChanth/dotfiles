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
    { import = "plugins.lang", cond = Util.platform.supports_lsp() },
    { import = "plugins.langs", cond = Util.platform.supports_lsp() },
    { import = "plugins.last" },
  },
  checker = { enabled = false }, -- disable check for updates
  change_detection = { enabled = false },
  colorscheme = { Util.colorscheme.get(), "catppuccin-mocha" },
  defaults = {
    lazy = true,
    version = "*",
  },
  -- dev = {
  --   -- To add a plugin to this folder use the following command
  --   -- ln -s /path/to/plugin/worktree ~/src/xc/local_nvim_plugins/plugin_name
  --   path = "~/src/xc/local_nvim_plugins",
  --   -- which plugins should be pulled locally
  --   patterns = { "xavierchanth" },
  --   fallback = true,
  -- },
  install = {
    missing = false,
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
