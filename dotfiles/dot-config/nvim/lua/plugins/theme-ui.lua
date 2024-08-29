local logos = require("util.logos")
local actions = require("util.dashboard").actions

local selected_logo = "nvim_sharp"
return {
  {
    "nvimdev/dashboard-nvim",
    opts = {
      config = {
        header = vim.split("\n\n" .. logos[selected_logo] .. "\n\n", "\n"),
        center = actions,
      },
    },
  },
  {
    "sschleemilch/slimline.nvim",
    lazy = false,
    opts = {
      spaces = {
        left = "",
        right = "",
      },
      sep = {
        hide = {
          first = true,
          last = true,
        },
        left = "",
        right = "",
      },
      hl = {
        modes = {
          normal = "Function", -- highlight base of modes
          insert = "String",
          pending = "Boolean",
          visual = "Keyword",
          command = "Boolean",
        },
        base = "Comment", -- highlight of everything in in between components
        primary = "Normal", -- highlight of primary parts (e.g. filename)
        secondary = "Comment", -- highlight of secondary parts (e.g. filepath)
      },
    },
  },
}
