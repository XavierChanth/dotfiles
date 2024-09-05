return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      cmake = { "gersemi" },
      markdown = { "markdownlint-cli2", "markdown-toc" },
    },
    formatters = {
      injected = {},
      shfmt = { prepend_args = { "-i", "2", "-ci" } },
      gersemi = { prepend_args = { "--indent", "2" } }, -- cmake formatter
      prettier = { prepend_args = { "--prose-wrap", "always" } },
    },
  },
}
