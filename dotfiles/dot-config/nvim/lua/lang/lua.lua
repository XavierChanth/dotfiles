return {
  Util.packages.ensure_installed({
    treesitter = { "lua", "luadoc", "luap" },
    mason = { "stylua", "lua_ls" },
  }),
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  {
    "blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          lsp = { "LazyDev", "path", "snippets", "buffer" },
        },
        providers = {
          -- dont show LuaLS require statements when lazydev has items
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = "lsp" },
        },
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
  },
  -- Additional plugins
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
}
