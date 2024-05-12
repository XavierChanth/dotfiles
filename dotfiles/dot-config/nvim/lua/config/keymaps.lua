-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

require("which-key").register({
  ["<leader>r"] = { name = "run" },
  ["<leader>t"] = { name = "tab stop" },
})

-- Jump 5 lines at a time
map("n", "<C-j>", "5j")
map("n", "<C-k>", "5k")

-- run commands with telescope
map("n", "<leader>rr", "<cmd>Telescope commands<cr>", { desc = "Run commands" })
map("n", "<leader>rg", "<cmd>Gitsigns<cr>", { desc = "Gitsigns Commands" })

-- map leader y/p to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { remap = true, desc = "yank to clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { remap = true, desc = "paste from clipboard" })

-- Shift + Space = Space in Terminal Mode
map("t", "<S-Space>", "<Space>", { noremap = true })

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

-- Buffer management
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete Other Buffers" })
