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

-- Specific format methods

vim.api.nvim_create_user_command("Jq", '<cmd>%!jq', {})

-- You have to double % for prettier because it can't infer the filetype
-- if you pipe over stdout. The first % tells nvim to replace the file, the
-- second tells prettier where to read the file from.
vim.api.nvim_create_user_command("Prettier", '<cmd>%!prettier %', {})
