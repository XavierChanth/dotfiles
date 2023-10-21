require('xavierchanth.lazy-init')
local lsp  = require('xavierchanth.config.lsp')
require('lazy').setup({
  require('xavierchanth.config.global'),
  require('xavierchanth.config.common'),
  require('xavierchanth.config.files'),
  require('xavierchanth.config.keybinds'),
  require('xavierchanth.config.telescope'),
  require('xavierchanth.config.theme'),
  require('xavierchanth.config.treesitter'),
  lsp.dependencies,
}, {
  custom_keys = {
    ["<localleader>l"] = false,
    ["<localleader>t"] = false,
  }
})

-- Shared settings between nvim and vscode-nvim
require('xavierchanth.config.global')

-- [[ Configure nvim-tree ]]
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- Toggle [E]xplorer

require 'nvim-tree.view'.View.winopts.relativenumber = true

-- Call the LSP setup function
lsp.setup()
