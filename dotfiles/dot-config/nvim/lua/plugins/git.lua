return {
  {
    "ThePrimeagen/git-worktree.nvim",
    commit = "a3917d0b7ca32e7faeed410cd6b0c572bf6384ac", -- PR #124
    keys = {
      {
        "<leader>ga",
        -- Override the implementation, no extra dialog
        function()
          local create_worktree = function(opts)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            opts = opts or {}
            opts.attach_mappings = function()
              actions.select_default:replace(function(prompt_bufnr, asdf)
                local selected_entry = action_state.get_selected_entry()
                local current_line = action_state.get_current_line()

                vim.print(asdf)
                actions.close(prompt_bufnr)

                local branch = selected_entry ~= nil and selected_entry.value or current_line

                if branch == nil then
                  return
                end

                local name = branch:gsub("^origin/", "", 1)
                local path = require("util.git").bareRoot() .. "/" .. name

                require("git-worktree").create_worktree(path, name)
              end)

              return true
            end
            require("telescope.builtin").git_branches(opts)
          end
          create_worktree()
        end,
        desc = "Git worktree add",
      },
      {
        "<leader>gw",
        function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "Git worktrees",
      },
    },
    opts = {
      update_on_change_command = "true",
    },
    config = function()
      require("telescope").load_extension("git_worktree")

      local Worktree = require("git-worktree")

      Worktree.on_tree_change(function(op, _)
        if op == Worktree.Operations.Create then
          local Process = require("lazy.manage.process")
          local ok, _ = pcall(
            Process.exec,
            { "git", "config", "remote.origin.fetch", "+refs/heads/*:refs/remotes/origin/*" },
            { cwd = require("util.git").worktreeRoot() }
          )

          if not ok then
            LazyVim.error({
              'Failed to configure upstream. Please run:  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"',
            })
          end
        end
      end)
    end,
  },
}
