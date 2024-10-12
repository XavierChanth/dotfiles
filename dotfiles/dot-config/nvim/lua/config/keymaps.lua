-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local unmap = vim.keymap.del

-- Don't use this keymaps with VSCode, use vscode.lua instead
if vim.g.vscode then
  require("config/vscode")
  return
end

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

-- Terminal
map("n", "<C-_>", function()
  require("util.terminal").open_last_terminal()
end, { desc = "Terminal (Last)" })
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

--Splits
map("n", "<leader>\\", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Buffer management
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete Other Buffers" })
map("n", "<leader>br", "<cmd>bd|e#<cr>", { desc = "Reopen buffer" })
unmap("n", "<S-h>")
unmap("n", "<S-l>")

-- Indentation
map("n", "<leader>t2", function()
  tabstop(2)
end, { desc = "2 spaces" })

map("n", "<leader>t4", function()
  tabstop(4)
end, { desc = "4 spaces" })

map("n", "<leader>t8", function()
  tabstop(8)
end, { desc = "4 spaces" })

-- Tabs the annoying thing
map("n", "<leader><tab>c", "<cmd>tabnew<cr>", { desc = "Tab Create" })
map("n", "<leader><tab>h", "<cmd>tabnext -1<cr>", { desc = "Tab Left" })
map("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Tab Right" })
unmap("n", "<leader><tab><tab>")
unmap("n", "<leader><tab>f")
unmap("n", "<leader><tab>[")
unmap("n", "<leader><tab>]")
