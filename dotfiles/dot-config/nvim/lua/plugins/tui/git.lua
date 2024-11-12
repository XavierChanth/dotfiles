return {
  {
    "echasnovski/mini.diff",
    event = "VeryLazy",
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle mini.diff overlay",
      },
    },
    opts = {
      view = {
        style = "sign",
        signs = {
          add = "▎",
          change = "▎",
          delete = "",
        },
      },
    },
  },
  {
    "polarmutex/git-worktree.nvim",
    keys = {
      {
        "<leader>gc",
        Util.worktree.add,
        desc = "Git worktree add",
      },
      {
        "<leader>gw",
        Util.worktree.telescope,
        desc = "Git worktrees",
      },
    },
    config = Util.worktree.config,
  },
}
