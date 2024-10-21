local diagnostic_icons = require("util.symbols").diagnostics

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      registries = {
        "github:xavierchanth/mason-registry",
        "github:mason-org/mason-registry",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    dependencies = {
      "mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          prefix = "icons", -- "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
            [vim.diagnostic.severity.WARN] = diagnostic_icons.Warn,
            [vim.diagnostic.severity.HINT] = diagnostic_icons.Hint,
            [vim.diagnostic.severity.INFO] = diagnostic_icons.Info,
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
      codelens = {
        enabled = false,
      },
      document_highlight = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
    },
    config = function(_, opts)
      -- setup keymaps
      require("util.lsp").on_attach(function(client, buffer)
        require("util.lsp_keymaps").on_attach(client, buffer)
      end)

      require("util.lsp").setup()
      require("util.lsp").on_dynamic_capability(require("util.lsp_keymaps").on_attach)

      require("util.lsp").words.setup(opts.document_highlight)


      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local mlsp = require("mason-lspconfig")
      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      mlsp.setup({
        ensure_installed = vim.tbl_deep_extend(
          "force",
          ensure_installed,
          require("util.lazy").opts("mason-lspconfig.nvim").ensure_installed or {}
        ),
        handlers = { setup },
      })
    end,
  },
}
