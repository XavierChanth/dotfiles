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
      worktree = { bare = { path = ".." } },
      settings = {
        add = {
          base = "smart",
          on_existing = Util.worktree.arbor_post_switch,
        },
      },
      actions = {
        add = {
          ["add new branch"] = function(info)
            require("arbor").actions.add_new_branch(info)
          end,
        },
        pick = {
          ["remove worktree"] = function()
            require("arbor").remove()
          end,
        },
      },
      hooks = {
        pre_add = function(info)
          return Util.worktree.arbor_pre_add(info)
        end,
        post_add = function(info)
          return Util.worktree.arbor_post_add(info)
        end,
        pre_pick = function(info)
          return Util.worktree.arbor_pre_switch(info)
        end,
        post_pick = function(info)
          return Util.worktree.arbor_post_switch(info)
        end,
        pre_remove = function(info)
          return Util.worktree.arbor_pre_remove(info)
        end,
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
      {
        "<leader>gw",
        function()
          require("arbor").pick()
        end,
        desc = "Git Worktree",
      },
    },
  },
}
