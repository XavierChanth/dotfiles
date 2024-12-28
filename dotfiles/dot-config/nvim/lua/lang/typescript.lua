return {
  Util.packages.ensure_installed({
    treesitter = { "typescript", "javascript" },
    mason = { "vtsls", "tailwindcss" },
  }),
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {},
        tailwindcss = {},
      },
    },
  },
}
