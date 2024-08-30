local logos = require("util.logos")
local actions = require("util.dashboard").actions

local slimline_themes = {
  minimal = {
    style = "fg",
    spaces = { left = "", right = "" },
    sep = {
      hide = { first = true, last = true },
      left = "",
      right = "",
    },
  },
  bubble = {
    spaces = { left = "", right = "" },
    sep = {
      hide = { first = true, last = true },
      left = "",
      right = "",
    },
  },
}

local selected_logo = "nvim_sharp"
local selected_theme = "minimal"

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
    opts = vim.tbl_extend("force", {
      hl = {
        modes = {
          normal = "Function", -- blue
          insert = "String", -- green
          pending = "error", -- red
          visual = "Keyword", -- purple
          command = "Boolean", -- orange
        },
      },
    }, slimline_themes[selected_theme]),
  },
}
