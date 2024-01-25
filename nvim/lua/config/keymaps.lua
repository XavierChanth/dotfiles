-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Shift + Space = Space in Terminal Mode
map("t", "<S-Space>", "<Space>", { noremap = true })

-- Neo-tree : Open & focus, or close if already focused
-- vim.keymap.set("n", "<leader>fe", function()
--   local renderer = require("neo-tree.ui.renderer")
--   local cmd = require("neo-tree.command")
--   local state = require("neo-tree.sources.manager").get_state("filesystem")
--   if renderer.window_exists(state) then
--     if state.winid == vim.api.nvim_get_current_win() then
--       renderer.close(state)
--     else
--       cmd.execute({ focus = true, dir = Util.root() })
--     end
--   else
--     cmd.execute({ focus = true, dir = Util.root() })
--   end
-- end, { noremap = true, silent = true })
