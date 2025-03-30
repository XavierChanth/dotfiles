return {
  {
    "sschleemilch/slimline.nvim",
    event = "VeryLazy",
    opts = {
      style = "fg",
      spaces = { left = "", right = "" },
      sep = {
        hide = { first = true, last = true },
        left = "",
        right = "",
      },
      components = {
        left = {
          "mode",
          "path",
          Util.statusline.branch_component,
        },
        right = {
          Util.statusline.command_component,
          Util.statusline.mode_component,
          "diagnostics",
          Util.statusline.python_kernel_component,
          "filetype_lsp",
          "progress",
        },
      },
      hl = {
        modes = {
          normal = "MiniIconsBlue",
          insert = "MiniIconsGreen",
          pending = "MiniIconsRed",
          visual = "MiniIconsPurple",
          command = "MiniIconsOrange",
        },
      },
    },
  },
}
