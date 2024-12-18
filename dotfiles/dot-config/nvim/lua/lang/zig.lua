return {
  Util.packages.ensure_installed({
    treesitter = { "zig" },
    mason = { "zls" },
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
