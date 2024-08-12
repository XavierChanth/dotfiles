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
    "NStefan002/screenkey.nvim",
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
}
