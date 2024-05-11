-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

require("which-key").register({
	["<leader>r"] = { name = "run" },
	["<leader>t"] = { name = "tab stop" },
})

-- oil.nvim
map("n", "<leader>e", function()
	require("oil").open()
end, { desc = "Oil" })
map("n", "<leader>E", function()
	require("oil").open(require("lazyvim.util.root").git())
end, { desc = "Oil (root dir)" })

-- run commands with telescope
map("n", "<leader>rr", "<cmd>Telescope commands<cr>", { desc = "Run commands" })

-- map leader y/p to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { remap = true, desc = "yank to clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { remap = true, desc = "paste from clipboard" })

-- Shift + Space = Space in Terminal Mode
map("t", "<S-Space>", "<Space>", { noremap = true })

-- LSP symbol_width
map("n", "<leader>ss", function()
	require("telescope.builtin").lsp_document_symbols({
		symbols = require("lazyvim.config").get_kind_filter(),
		symbol_width = 64,
	})
end, { desc = "Goto Symbol" })
map("n", "<leader>sS", function()
	require("telescope.builtin").lsp_dynamic_workspace_symbols({
		symbols = require("lazyvim.config").get_kind_filter(),
		symbol_width = 64,
	})
end, {
	desc = "Goto Symbol (Workspace)",
})

-- Tab stops
local tabstop = function(num)
	vim.opt.tabstop = num
	vim.opt.shiftwidth = num
end

map("n", "<leader>t2", function()
	tabstop(2)
end, { desc = "2 spaces" })

map("n", "<leader>t4", function()
	tabstop(4)
end, { desc = "4 spaces" })

map("n", "<leader>t8", function()
	tabstop(8)
end, { desc = "4 spaces" })

-- Gitsigns
map("n", "<leader>rg", ":Gitsigns<CR>", { desc = "Gitsigns Commands" })
