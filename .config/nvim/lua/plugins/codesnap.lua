return {
  "mistricky/codesnap.nvim",
  build = "make",
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
}
