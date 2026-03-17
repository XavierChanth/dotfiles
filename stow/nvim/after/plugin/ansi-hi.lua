
vim.api.nvim_create_user_command("AnsiHighlight", function()
  require("utils.ansi-hi").apply()
end, {})

