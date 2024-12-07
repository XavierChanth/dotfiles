Util.git.keymaps()

return {
  {
    "FabijanZulj/blame.nvim",
    cmd = "BlameToggle",
    keys = { { "<leader>gB", "<cmd>BlameToggle window<cr>", desc = "Blame" } },
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
        desc = "Diff overlay",
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
