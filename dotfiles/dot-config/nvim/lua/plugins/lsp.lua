local uname = vim.loop.os_uname()
local is_linux_arm64 = uname.sysname == "Linux" and uname.machine == "aarch64"
local no_mason_linux_arm64 = { mason = not is_linux_arm64 }
local function get_flutter_bin_path()
  return require("os").getenv("FLUTTER_ROOT") .. "/bin/"
end
return {
  -- lsp
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
    commit = "94874383aea04f259a81cf9e40750be60d5bcb30", -- v0.1.7 doesn't have ruff support yet so lets use a commit that does
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
    "akinsho/flutter-tools.nvim",
    event = "BufReadPre *.dart,pubspec.yaml",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>rf",
        function()
          require("telescope").extensions.flutter.commands()
        end,
        desc = "Flutter Commands",
      },
    },
    config = {
      flutter_path = get_flutter_bin_path() .. "flutter",
      lsp = {
        root_dir = function()
          return vim.loop.cwd()
        end,
        init_options = {
          onlyAnalyzeProjectsWithOpenFiles = false,
          closingLabels = true,
        },
        settings = {
          lineLength = 80,
          -- renameFilesWithClasses = "always",
        },
      },
    },
  },
  -- formatting
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
        prettier = { prepend_args = { "--prose-wrap", "always" } },
      },
    },
  },
  -- cmp
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })
      end,
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.preselect = cmp.PreselectMode.None
      opts.completion.completeopt = "menu,menuone,preview,noselect,noinsert"
      opts.mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }
    end,
  },
  -- dap
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      local ft = require("mason-nvim-dap.mappings.filetypes")
      ft.lldb = ft.codelldb
      local dap = require("dap")
      dap.adapters.lldb = require("mason-nvim-dap.mappings.adapters.codelldb")
      require("util.dotenv").load(vim.fs.find(".env", { type = "file", root_dir = require("util.root").git() })[1])
    end,
  },
  -- config
  {
    "folke/neoconf.nvim",
    opts = {
      local_settings = ".local/neoconf.json",
    },
  },
}
