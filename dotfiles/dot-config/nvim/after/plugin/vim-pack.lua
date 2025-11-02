vim.api.nvim_create_user_command(
  "PackUpdate",
  "lua vim.pack.update()",
  {}
)

vim.api.nvim_create_user_command(
  "PackInstall",
  [[lua require("utils/pack").install()]],
  {}
)
