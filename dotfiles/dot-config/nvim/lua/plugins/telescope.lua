return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    keys = {
      {
        "<leader><space>",
        require("util.telescope").git_files,
        desc = "Git files",
      },
      {
        "<leader>ff",
        require("util.telescope").find_files,
        desc = "Find files",
      },
      {
        "<leader>fF",
        function()
          require("util.telescope").find_files({ cwd = vim.uv.cwd() })
        end,
        desc = "Find files",
      },

      {
        "<leader>fb",
        function()
          require("util.telescope").builtin("buffers", {})
        end,
        desc = "Find buffers",
      },
    },
    opts = {
      defaults = require("util.telescope").defaults,
      pickers = {
        commands = {
          entry_maker = require("util.telescope").command.entry_maker({}),
        },
        lsp_document_symbols = {
          symbol_width = 48,
        },
        lsp_dynamic_workspace_symbols = {
          fname_width = 48,
          symbol_width = 48,
        },
      },
      extensions = {
        undo = {
          use_delta = true,
          mappings = {
            i = {
              ["<cr>"] = function(prompt_bufnr)
                return require("telescope-undo.actions").restore(prompt_bufnr)
              end,
              ["<C-y>"] = function(prompt_bufnr)
                return require("telescope-undo.actions").yank_additions(prompt_bufnr)
              end,
              ["<C-Y>"] = function(prompt_bufnr)
                return require("telescope-undo.actions").yank_deletions(prompt_bufnr)
              end,
            },
            n = {
              ["<cr>"] = function(prompt_bufnr)
                return require("telescope-undo.actions").restore(prompt_bufnr)
              end,
              ["y"] = function(prompt_bufnr)
                return require("telescope-undo.actions").yank_additions(prompt_bufnr)
              end,
              ["Y"] = function(prompt_bufnr)
                return require("telescope-undo.actions").yank_deletions(prompt_bufnr)
              end,
            },
          },
        },
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
  {
    "ThePrimeagen/git-worktree.nvim",
    commit = "a3917d0b7ca32e7faeed410cd6b0c572bf6384ac", -- PR #124
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
    config = function()
      require("telescope").load_extension("git_worktree")

      local Worktree = require("git-worktree")
      Worktree.on_tree_change(function(op, _)
        if op == Worktree.Operations.Create then
          local Job = require("plenary.job")

          Job
            :new({
              command = "git",
              args = { "config", "remote.origin.fetch", "+refs/heads/*:refs/remotes/origin/*" },
              cwd = require("util.root").git(),
              on_exit = function(_, exit_code)
                if exit_code ~= 0 then
                  LazyVim.error({
                    'Failed to configure upstream. Please run:  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"',
                  })
                end
              end,
            })
            :sync()
        end
      end)
      return {
        update_on_change_command = "",
      }
    end,
  },
}
