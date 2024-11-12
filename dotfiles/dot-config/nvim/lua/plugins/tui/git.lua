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
    "xavierchanth/arbor.nvim",
    ---@type arbor.config
    opts = {
      worktree = { bare = { path = "../" } },
      settings = { add = { base = "smart" } },
      actions = {
        add = {
          ["add new branch"] = function(info)
            require("arbor").actions.add_new_branch(info)
          end,
        },
      },
    },
    config = function(_, opts)
      require("arbor").setup(opts)
    end,
    keys = {
      {
        "<leader>ga",
        function()
          require("arbor").add()
        end,
        desc = "Git Worktree Add",
      },
    },
  },
  {
    "polarmutex/git-worktree.nvim",
    keys = {
      {
        "<leader>gw",
        function(...)
          Util.worktree.telescope(...)
        end,
        desc = "Git worktrees",
      },
    },
    config = function()
      Util.worktree.config()
    end,
  },
}
