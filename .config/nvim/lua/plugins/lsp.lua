local uname = vim.loop.os_uname()
-- Note: dart & flutter configured in ./flutter.lua
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lsp
        "bash-language-server",
        "clangd",
        "lua-language-server",
        -- formatter
        "shfmt",
        "gersemi",
        "stylua",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = not (uname.sysname == "Linux" and uname.machine == "aarch64"),
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
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cmake = { "gersemi" },
      },
      formatters = {
        injected = {},
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
        gersemi = { prepend_args = { "--indent", "2" } },
      },
    },
  },
}
