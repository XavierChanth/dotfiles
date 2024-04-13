-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local Util = require("lazyvim.util")

require("which-key").register({
  ["<leader>r"] = { name = "run" },
  ["<leader>ue"] = { name = "Explorer position" },
  ["<leader>t"] = { name = "tab stop" },
})

local tmux_session_command = function()
  if vim.env.TMUX ~= nil then
    -- TODO - Add a new custom window to tmux?
    return nil
  end

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

-- Telescope
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
