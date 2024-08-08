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
    commit = "75b44c5ddab5dd16440bfaa82075475d019e509d",
    cmd = { "Screenkey" },
    opts = {
      win_opts = {
        border = "rounded",
        title = "",
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
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "edluffy/hologram.nvim",
    opts = {
      auto_display = true,
    },
  },
}
