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
        "<leader>ga",
        require("util.git_worktree").add,
        desc = "Git worktree add",
      },
      {
        "<leader>gw",
        require("util.git_worktree").telescope,
        desc = "Git worktrees",
      },
    },
    config = require("util.git_worktree").config,
  },

}
