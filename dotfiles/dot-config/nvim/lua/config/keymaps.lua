-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local unmap = vim.keymap.del

require("which-key").add({
  { "<leader>gh", group = "Git " },
  { "<leader>r", group = "run" },
  { "<leader>t", group = "tab stop" },
})

-- run commands with telescope
map("n", "<leader>rr", "<cmd>Telescope commands<cr>", { desc = "Run commands" })

-- map leader y/p to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { remap = true, desc = "yank to clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { remap = true, desc = "paste from clipboard" })

-- Shift + Space = Space in Terminal Mode
map("t", "<S-Space>", "<Space>", { noremap = true })

-- Use my bare repo compatible Lazygit wrapper
map("n", "<leader>gg", function()
  require("util.lazygit").lazygit()
end, { desc = "Lazygit" })
map("n", "<leader>gG", function() end)

-- gh-dash
map("n", "<leader>gr", function()
  require("util.terminal").terminal({ "gh", "dash" })
end, { desc = "GitHub Reviews Dashboard" })

-- LazyVim's default terminal mappings
unmap("n", "<leader>ft")
unmap("n", "<leader>fT")

-- Yazi
map("n", "<leader>fe", function()
  require("util.terminal").terminal({ "yazi" })
end, { desc = "Open Yazi" })

-- Tab stops
local tabstop = function(num)
  vim.opt.tabstop = num
  vim.opt.shiftwidth = num
end

-- Buffer management
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete Other Buffers" })
unmap("n", "<S-h>")
unmap("n", "<S-l>")

-- Tabs
map("n", "<leader>t2", function()
  tabstop(2)
end, { desc = "2 spaces" })

map("n", "<leader>t4", function()
  tabstop(4)
end, { desc = "4 spaces" })

map("n", "<leader>t8", function()
  tabstop(8)
end, { desc = "4 spaces" })
