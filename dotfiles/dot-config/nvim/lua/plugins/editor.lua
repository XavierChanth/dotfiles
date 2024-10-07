return {
  {
    "folke/todo-comments.nvim",
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
  {
    "debugloop/telescope-undo.nvim",
    keys = {
      {
        "<leader>uh",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    config = function()
      require("telescope").load_extension("undo")
    end,
  },
}
