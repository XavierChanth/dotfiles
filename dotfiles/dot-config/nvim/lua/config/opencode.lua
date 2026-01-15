vim.g.opencode_opts = {
  provider = {
    enabled = "tmux",
    tmux = {},
  },
}

vim.keymap.set({ "n", "x" }, "<C-x>", function()
  require("opencode").select()
end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "<C-.>", function()
  require("opencode").toggle()
end, { desc = "Toggle opencode" })

require("opencode")
