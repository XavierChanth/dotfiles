return {
  Util.packages.ensure_installed({
    treesitter = { "rust", "ron" },
    mason = { "rust-analyzer" },
  }),
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {},
      },
    },
  },

  -- Additional plugins
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}
