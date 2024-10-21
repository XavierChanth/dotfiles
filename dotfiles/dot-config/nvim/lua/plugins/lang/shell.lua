return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "shfmt",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
      },
    },
  },
}
