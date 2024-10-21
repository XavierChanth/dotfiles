return {
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
    opts = {
      save_path = vim.env.HOME .. "/Desktop",
      watermark = "",
    },
  },
  {
    "nvchad/showkeys",
    cmd = "ShowkeysToggle",
    keys = {
      {
        "<leader>uk",
        function()
          vim.cmd("ShowkeysToggle")
        end,
        desc = "Showkeys (toggle)",
      },
    },
    opts = {
      timeout = 1,
      maxkeys = 3,
      show_count = true,
    },
  },
}
