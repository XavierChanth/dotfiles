return {
  require("util.lazy").ensure_installed({
    conform = { "shfmt" },
  }),
  {
    "conform.nvim",
    opts = {
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
      },
    },
  },
}
