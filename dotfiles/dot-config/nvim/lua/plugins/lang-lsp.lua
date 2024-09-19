local uname = vim.uv.os_uname()
local is_linux_arm64 = uname.sysname == "Linux" and uname.machine == "aarch64"
local no_mason_linux_arm64 = { mason = not is_linux_arm64 }

return {
  {
    "williamboman/mason.nvim",
    opts = {
      registries = {
        "github:xavierchanth/mason-registry",
        "github:mason-org/mason-registry",
      },
      ensure_installed = {
        -- lsp
        "lua-language-server",
        -- formatter
        "shfmt",
        "stylua",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        gopls = no_mason_linux_arm64,
        pyright = no_mason_linux_arm64,
        dockerls = no_mason_linux_arm64,
        docker_compose_language_service = no_mason_linux_arm64,
        clangd = {
          mason = not is_linux_arm64,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--query-driver=/usr/bin/clang++",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
    },
  },
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
  },
}
