local map = vim.keymap.set
map("n", "<leader>gl", function()
  Util.floats.lazygit()
end, { desc = "LazyGit" })

map("n", "<leader>gg", function()
  Util.jj.float()
end, { desc = "JJ terminal" })

map("n", "<leader>gh", function()
  local opts = { args = { "-f", vim.fn.expand("%") } }
  Util.floats.lazygit(opts)
end, { desc = "File history" })

return {
  {
    "FabijanZulj/blame.nvim",
    cmd = "BlameToggle",
    keys = { { "<leader>gb", "<cmd>BlameToggle window<cr>", desc = "Blame" } },
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
