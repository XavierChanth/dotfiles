local virtual_lines_enabled = false
vim.diagnostic.config({
  virtual_lines = virtual_lines_enabled,
  update_in_insert = not virtual_lines_enabled,
  underline = true,
})

vim.keymap.set("n", "<leader>xv", function()
  virtual_lines_enabled = not virtual_lines_enabled
  vim.diagnostic.config({
    virtual_lines = virtual_lines_enabled,
    update_in_insert = not virtual_lines_enabled,
  })
end, { desc = "Diagnostics: Toggle Virtual Lines" })

return {
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      auto_preview = false,
    },
    keys = {
      { "<leader>x", "", desc = "+diagnostics" },
      { "<leader>xl", "<cmd>lopen<cr>", desc = "Location List" },
      { "<leader>xq", "<cmd>copen<cr>", desc = "Quickfix List" },
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      {
        "<leader>xS",
        "<cmd>Trouble lsp toggle<cr>",
        desc = "LSP references/definitions/... (Trouble)",
      },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    keys = {
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      {
        "<leader>xT",
        "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
        desc = "Todo/Fix/Fixme (Trouble)",
      },
      { "<leader>st", "<cmd>TodoFzfLua<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoFzfLua keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
    opts = {
      -- Had to override all of them so I could add highlighting to plurals
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODOS = { icon = " ", color = "info", alt = { "TODO" } },
        HACKS = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTES = { icon = " ", color = "hint", alt = { "NOTE", "INFO" } },
        TESTS = { icon = "⏲ ", color = "test", alt = { "TEST", "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*]],
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]],
      },
    },
  },
}
