return {
  Util.packages.ensure_installed({
    treesitter = { "zig" },
    lsp = { "zls" },
  }),
  {
    "nvim-lspconfig",
    opts = {
      servers = { zls = {} },
    },
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        zig = { "zigfmt" },
      },
    },
  },
}
