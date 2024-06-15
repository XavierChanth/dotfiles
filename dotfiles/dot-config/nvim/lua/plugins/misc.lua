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
  {
    "folke/persistence.nvim",
    lazy = false,
    opts = {
      save_empty = true,
    },
  },
  {
    "mistricky/codesnap.nvim",
    keys = {
      {
        "<leader>cs",
        function()
          local cs = require("codesnap")
          cs.copy_into_clipboard()
        end,
        mode = "v",
        desc = "Codesnap (clipboard)",
      },
    },
    config = {
      save_path = vim.env.HOME .. "/Desktop",
      watermark = "",
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "NStefan002/screenkey.nvim",
    cmd = { "Screenkey" },
    opts = {
      win_opts = {
        border = "rounded",
      },
      disable = {
        filetypes = {
          "toggleterm",
        },
        buftypes = {
          "terminal",
        },
      },
      group_mappings = true,
      display_infront = { "Telescope*" },
      display_behind = {},
    },
  },
}
