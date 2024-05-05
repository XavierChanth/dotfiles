-- Intentional override of lazyvim's config_files to be the entire dotfiles repo
local telescope = require("lazyvim.util.telescope")
---@diagnostic disable-next-line: duplicate-set-field
telescope.config_files = function()
  return telescope("files", {
    cwd = vim.fn.expand("$HOME/.dotfiles"),
    show_untracked = true,
    git_command = { "/bin/zsh", "-c", "git ls-files --exclude-standard --cached" },
  })
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader><space>",
        telescope.telescope("files", { cwd = require("lazyvim.util.root").git() }),
        desc = "Find files",
      },
    },
    opts = {
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
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
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
    config = function()
      require("telescope").load_extension("git_worktree")
    end,
  },
}
