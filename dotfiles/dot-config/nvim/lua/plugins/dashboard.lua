return {
  "snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
      preset = {
        header = Util.logo,
        keys = {

          {
            action = function()
              Util.floats.lazygit()
            end,
            desc = " git",
            icon = " ",
            key = "g",
          },
          {
            action = function()
              Util.jj.float()
              -- Util.floats.lazyjj()
            end,
            desc = " jj",
            icon = " ",
            key = "j",
          },
          {
            action = function()
              require("persistence").load()
            end,
            desc = " session",
            icon = " ",
            key = "s",
          },
          {
            action = ":qa",
            desc = " quit",
            icon = " ",
            key = "q",
          },
        },
      },
    },
  },
}
