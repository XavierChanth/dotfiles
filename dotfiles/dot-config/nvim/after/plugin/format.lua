vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.api.nvim_create_user_command(
  "W",
  "lua vim.g.autoformat = true; vim.cmd.w(); vim.g.autoformat = false",
  {}
)
vim.api.nvim_create_user_command(
  "Wa",
  "lua vim.g.autoformat = true; vim.cmd.wa(); vim.g.autoformat = false",
  {}
)
vim.api.nvim_create_user_command("Format", function()
  require("conform").format({})
end, {})
