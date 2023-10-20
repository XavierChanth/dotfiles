require('xavierchanth.lazy-init')

local setup, configure = require('xavierchanth.config.lsp')

require('lazy').setup({
  require('xavierchanth.config.global'),
  require('xavierchanth.config.common'),
  require('xavierchanth.config.files'),
  require('xavierchanth.config.keybinds'),
  require('xavierchanth.config.lsp'),
  require('xavierchanth.config.telescope'),
  require('xavierchanth.config.theme'),
  require('xavierchanth.config.treesitter')
}, {
  custom_keys = {
    ["<localleader>l"] = false,
    ["<localleader>t"] = false,
  }
})

require('xavierchanth.config.global')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ General settings ]]
-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- line wrapping
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- cursor line
vim.opt.cursorline = true

-- backspace
vim.opt.backspace = "indent,eol,start"

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Keep cursor from being stuck on last line
vim.opt.scrolloff = 8

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- [[ Configure nvim-tree ]]
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- Toggle [E]xplorer

require 'nvim-tree.view'.View.winopts.relativenumber = true
