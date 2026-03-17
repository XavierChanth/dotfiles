require("slimline").setup({
  style = "fg",
  spaces = { left = "", right = "" },
  sep = {
    hide = { first = true, last = true },
    left = "",
    right = "",
  },
  components = {
    left = { "mode", "path" },
    right = { "diagnostics", "filetype_lsp", "progress" },
  },
  configs = {
    modes = {
      hl = {
        normal = "MiniIconsBlue",
        insert = "MiniIconsGreen",
        pending = "MiniIconsRed",
        visual = "MiniIconsPurple",
        command = "MiniIconsOrange",
      },
    },
  },
})
