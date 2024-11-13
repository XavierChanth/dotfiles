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
      settings = { add = { base = "smart" } },
      actions = {
        add = {
          ["add new branch"] = function(info)
            require("arbor").actions.add_new_branch(info, {
              preserve_default_hooks = true,
              hooks = {
                post = function(i)
                  require("arbor").actions.push_upstream(i, { workdir = "new_path" })
                end,
              },
            })
          end,
        },
      },
      hooks = {
        pre_add = function(info)
          require("arbor").actions.fetch(info)
        end,
        post_add = function(info)
          require("arbor").actions.cd_new_path(info)
          require("arbor").actions.push_upstream(info)
          Util.worktree.arbor_set_dashboard(info)
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
