return {
  {
    "ThePrimeagen/git-worktree.nvim",
    commit = "a3917d0b7ca32e7faeed410cd6b0c572bf6384ac", -- PR #124
    keys = {
      {
        "<leader>ga",
        -- Override the implementation, no extra dialog
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
