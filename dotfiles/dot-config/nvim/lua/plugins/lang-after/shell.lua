return {
  {
    "mason.nvim",
    opts = {
      ensure_installed = { "shfmt" },
    },
  },
  {
    "conform.nvim",
    opts = {
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
      },
    },
  },
}
