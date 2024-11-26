return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
    config = function(_, opts)
      require("diffview").setup(opts)
      -- load neogit with diffview always
      require("lazy").load({ plugins = { "neogit" } })
    end,
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = { "diffview.nvim" },
    keys = {
      {
        "<leader>gg",
        function()
          Util.git.open()
        end,
        desc = "Neogit",
      },
      {
        "<leader>gc",
        function()
          Util.git.open({ cwd = vim.fs.dirname(vim.fn.expand("%")) })
        end,
        desc = "Neogit (current file)",
      },
      {
        "<leader>gd",
        function()
          require("arbor").pick({
            show_remote_branches = true,
            preserve_default_hooks = false,
            show_actions = false,
            select_opts = {
              prompt = "Diff against:",
            },
            hooks = {
              post = function(info)
                require("neogit.integrations.diffview").open("range", info.branch_info.display_name)
              end,
            },
          })
        end,
        desc = "Git diff",
      },
    },
    opts = {
      graph_style = "unicode",
      integrations = {
        diffview = true,
        fzf_lua = true,
      },
      commit_editor = {
        spell_check = false,
      },
    },
  },
  {
    "FabijanZulj/blame.nvim",
    cmd = "BlameToggle",
    keys = { { "<leader>gb", "<cmd>BlameToggle window<cr>", desc = "git blame" } },
    opts = { merge_consecutive = false },
  },
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
    ---@type arbor.config
    opts = {
      apply_recommended = false,
      select = "fzf",
      worktree = { bare = { path = ".." } },
      settings = {
        add = {
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
  },
}
