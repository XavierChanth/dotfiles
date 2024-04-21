local telescope = require("lazyvim.util.telescope")
-- Intentional override of lazyvim's config_files to be the entire dotfiles repo
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
    "nvim-telescope/telescope.nvim",
    opts = {
      extensions = {
        undo = {
          use_delta = true,
          mappings = {
            i = {
              ["<cr>"] = require("telescope-undo.actions").restore,
              ["<C-y>"] = require("telescope-undo.actions").yank_additions,
              ["<C-Y>"] = require("telescope-undo.actions").yank_deletions,
            },
            n = {
              ["<cr>"] = require("telescope-undo.actions").restore,
              ["y"] = require("telescope-undo.actions").yank_additions,
              ["Y"] = require("telescope-undo.actions").yank_deletions,
            },
          },
        },
      },
    },
  },
}
