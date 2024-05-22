local telescope = require("util.telescope")
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
        telescope.git_files,
        desc = "Git files",
      },
      {
        "<leader>ff",
        telescope.find_files,
        desc = "Find files",
      },
      {
        "<leader>fF",
        function()
          telescope.find_files({ cwd = vim.uv.cwd() })
        end,
        desc = "Find files",
      },
      {
        "<leader>fb",
        function()
          telescope.builtin("buffers", {})
        end,
        desc = "Find buffers",
      },
      {
        "<leader>j",
        function()
          telescope.builtin("buffers", {})
        end,
        desc = "Jump to buffer (telescope)",
      },
      {
        "<leader>uC",
        function()
          local colors = require("colors")
          telescope.builtin("colorscheme", {
            finder = require("util.telescope").finder_from_table(colors.configured),
            enable_preview = true,
            attach_mappings = function(prompt_bufnr, _)
              local actions = require("telescope.actions")
              local action_state = require("telescope.actions.state")
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                colors.switch(action_state.get_selected_entry().value)
              end)
              return true
            end,
          })
        end,
        desc = "Colorscheme with Preview",
      },
    },
    opts = {
      defaults = telescope.defaults,
      pickers = {
        commands = {
          entry_maker = telescope.command.entry_maker({}),
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

      local Job = require("plenary.job")
      local Worktree = require("git-worktree")
      Worktree.on_tree_change(function(op, _)
        if op == Worktree.Operations.Create then
          local _, exit_code = Job:new({
            command = "git",
            args = { "config", "remote.origin.fetch", "+refs/heads/*:refs/remotes/origin/*" },
            cwd = require("util.root").git(),
          }):sync()

          if exit_code ~= 0 then
            LazyVim.error({
              'Failed to configure upstream. Please run:  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"',
            })
          end
        end
      end)
      return {
        update_on_change_command = "lua require('oil').get_current_directory()",
      }
    end,
  },
}
