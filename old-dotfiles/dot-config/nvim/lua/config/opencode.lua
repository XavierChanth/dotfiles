require("opencode").setup({
  default_global_keymaps = false,
  keymap = {
    editor = {
      ["<leader>cc"] = { "quick_chat", mode = { "n", "x" } },
    },
  },
})
