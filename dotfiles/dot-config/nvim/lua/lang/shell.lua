return {
  Util.packages.ensure_installed({
    treesitter = { "bash" },
    mason = { "shellcheck", "shfmt" },
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
        -- zsh = { "shellcheck" },
      },
    },
  },
}
