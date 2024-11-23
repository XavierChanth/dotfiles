return {
  {
    "mistricky/codesnap.nvim",
    keys = {
      {
        "<leader>us",
        function()
          local cs = require("codesnap")
          cs.copy_into_clipboard()
        end,
        mode = "v",
        desc = "Codesnap (clipboard)",
      },
    },
    opts = {
      save_path = vim.env.HOME .. "/Desktop",
      watermark = "",
    },
  },
}
