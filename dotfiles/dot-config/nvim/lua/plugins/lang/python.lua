return {
  { import = "lazyvim.plugins.extras.lang.python" },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "pymarkdownlnt" },
      },
      linters = {
        pymarkdownlnt = {
          cmd = "pymarkdownlnt",
          stdin = true,
          args = {
            "-s",
            "plugins.md012.maximum=$#2",
            "scan-stdin",
          },
          stream = nil,
          ignore_exitcode = true,
          parser = require("lint.parser").from_errorformat("stdin:%l:%c: %m", {
            source = "pymarkdownlnt",
            severity = vim.diagnostic.severity.WARN,
          }),
        },
      },
    },

    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          pyright = { mason = not require("util.platform").is_linux_arm64() },
        },
      },
    },
  },
}
