return {
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*]],
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]],
      },
    },
  },
  { "echasnovski/mini.pairs", enabled = false },
  {
    "debugloop/telescope-undo.nvim",
    keys = {
      { -- lazy style key map
        "<leader>uh",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
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
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },
}
