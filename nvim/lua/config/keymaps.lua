-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local Util = require("lazyvim.util")

require("which-key").register({
  ["<leader>r"] = { name = "run" },
})

local tmux_session_command = function()
  local session = require("persistence").get_current()
  if session == nil then
    return "tmux"
  end
  session = session:match("([^/]+)$")
  session = session:gsub("%.", "-")
  session = session:gsub("%%", "_")
  return { "tmux", "new-session", "-A", "-s", session }
end

local lazyterm = function()
  Util.terminal(tmux_session_command(), { cwd = Util.root() })
end
map("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)", noremap = true })
map("n", "<leader>fT", function()
  Util.terminal(tmux_session_command())
end, { desc = "Terminal (cwd)", noremap = true })
map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)", noremap = true })
map("n", "<c-_>", lazyterm, { desc = "which_key_ignore", noremap = true })

-- Shift + Space = Space in Terminal Mode
map("t", "<S-Space>", "<Space>", { noremap = true })

-- Flutter Command Picker
map("n", "<leader>rf", function()
  require("telescope").extensions.flutter.commands()
end, { desc = "Flutter Commands" })
