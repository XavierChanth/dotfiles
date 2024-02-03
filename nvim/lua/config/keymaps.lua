-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

require("which-key").register({
  ["<leader>r"] = { name = "run" },
})

-- Shift + Space = Space in Terminal Mode
map("t", "<S-Space>", "<Space>", { noremap = true })

-- Flutter Command Picker
map("n", "<leader>rf", function()
  require("telescope").extensions.flutter.commands()
end, { desc = "Flutter Commands" })

-- CMake Command Picker
-- require("config.extras.cmake-picker").setup()
