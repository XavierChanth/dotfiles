vim.keymap.set("n", "<leader>xx", function()
  vim.diagnostic.setqflist()
end, {})
