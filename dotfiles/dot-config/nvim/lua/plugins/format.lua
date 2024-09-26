return {
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        injected = {},
        prettier = { prepend_args = { "--prose-wrap", "always" } },
      },
    },
  },
}
