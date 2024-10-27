return {
  require("util.lazy").ensure_installed({
    lint = { "shellcheck" },
    conform = { "shfmt" },
  }),
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        zsh = { "shfmt" },
      },
    },
  },
  {
    "nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        zsh = { "shfmt" },
      },
    },
  },
}
