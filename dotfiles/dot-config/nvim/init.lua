P = function(...)
  vim.print(vim.inspect(...))
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable built-in plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_tutor_mode_plugin = 1

require("options")
require("ft")
require("keymaps")

local pack = require("utils.pack")
local spec = require("assets.pack-spec")

pack.load(spec.init)

for ft, ft_spec in pairs(spec.ft) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    once = true,
    callback = function()
      pack.load(ft_spec)
    end,
  })
end

vim.api.nvim_create_autocmd("UIEnter", {
  command = "colorscheme tokyonight-cterm",
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("lsp")
    pack.load(spec.lazy)
  end,
})
