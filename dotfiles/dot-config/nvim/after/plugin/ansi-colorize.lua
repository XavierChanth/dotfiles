
vim.api.nvim_create_user_command("AnsiColorize", function()
  require("ansi_colorize").apply()
end, {})

