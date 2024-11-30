return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
    config = function(_, opts)
      require("diffview").setup(opts)
      -- load neogit with diffview always
      require("lazy").load({ plugins = { "neogit" } })
    end,
  },
  {
    "FabijanZulj/blame.nvim",
    cmd = "BlameToggle",
    keys = { { "<leader>gb", "<cmd>BlameToggle window<cr>", desc = "git blame" } },
    opts = { merge_consecutive = false },
  },
  {
    "echasnovski/mini.diff",
    event = "VeryLazy",
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle mini.diff overlay",
      },
    },
    opts = {
      view = {
        style = "sign",
        signs = {
          add = "▎",
          change = "▎",
          delete = "",
        },
      },
    },
  },
}
