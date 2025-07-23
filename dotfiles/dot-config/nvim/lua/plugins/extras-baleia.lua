local baleia = nil
return {
  "m00qek/baleia.nvim",
  version = "*",
  lazy = true,
  config = function()
    baleia = require("baleia").setup({})

    -- Command to colorize the current buffer
    vim.api.nvim_create_user_command("AnsiColorize", function()
      baleia.once(vim.api.nvim_get_current_buf())
    end, { bang = true })

    -- Command to show logs
    vim.api.nvim_create_user_command("AnsiLogs", baleia.logger.show, { bang = true })
  end,
  cmd = { "AnsiColorize", "AnsiLogs" },
  keys = {
    { "<leader>ua", "<cmd>AnsiColorize<cr>", desc = "Colorize ANSI escape codes" },
  },
}
