return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "t", "i" } },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "t", "i" } },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "t", "i" } },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "t", "i" } },
    },
  },
}
