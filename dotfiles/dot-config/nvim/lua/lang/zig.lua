return {
  Util.packages.ensure_installed({
    treesitter = { "zig" },
    lsp = { "zls" },
  }),
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = { zls = {} },
    },
  },
}
