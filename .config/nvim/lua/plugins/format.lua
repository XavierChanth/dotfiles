return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      injected = {},
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
    },
  },
}
