require("render-markdown").setup({
  file_types = { "markdown", "md", "AgenticChat" },
  code = {
    sign = false,
    conceal_delimiters = false,
    highlight_border = false,
    width = "block",
    min_width = 80,
    right_pad = 1,
  },
  heading = {
    sign = false,
    icons = {},
    width = "block",
    min_width = 80,
  },
  html = {
    enabled = true,
    comment = { conceal = false },
  },
})
