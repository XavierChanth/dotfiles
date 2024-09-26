return {
  { import = "lazyvim.plugins.extras.lang.go" },
  {
    "maxandron/goplements.nvim",
    ft = "go",
    opts = {
      -- The prefixes prepended to the type names
      prefix = {
        interface = "implemented by: ",
        struct = "implements: ",
      },
      -- Whether to display the package name along with the type name (i.e., builtins.error vs error)
      display_package = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = { mason = not require("util.platform").is_linux_arm64() },
      },
    },
  },
}
