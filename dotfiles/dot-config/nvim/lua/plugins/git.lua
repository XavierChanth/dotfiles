return {
  {
    "ThePrimeagen/git-worktree.nvim",
    commit = "a3917d0b7ca32e7faeed410cd6b0c572bf6384ac", -- PR #124
    keys = {
      {
        "<leader>ga",
        require("util.git").worktreeAdd,
        desc = "Git worktree add",
      },
      {
        "<leader>gw",
        require("util.git").worktrees,
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
          local Job = require("plenary.job")

          Job
            :new({
              command = "git",
              args = { "config", "remote.origin.fetch", "+refs/heads/*:refs/remotes/origin/*" },
              cwd = require("util.git").worktreeRoot(),
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
    end,
  },
}
