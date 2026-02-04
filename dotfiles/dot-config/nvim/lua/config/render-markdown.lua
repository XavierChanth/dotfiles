require("render-markdown").setup({
  file_types = { "markdown", "md", "AgenticChat" },
  code = {
    sign = false,
    conceal_delimiters = false,
    highlight_border = false,
    width = "block",
    right_pad = 1,
  },
  heading = {
    sign = false,
    icons = {},
  },
  html = {
    enabled = true,
    comment = { conceal = false },
  },
})
