return {
  Util.packages.ensure_installed({
    treesitter = { "svelte" },
  }),
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        svelte = {},
      },
    },
  },
}
