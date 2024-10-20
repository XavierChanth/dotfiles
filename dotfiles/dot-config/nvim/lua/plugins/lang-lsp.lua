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
      require("util.format").register(require("util.lsp").formatter())

      -- setup keymaps
      require("util.lsp").on_attach(function(client, buffer)
        require("keymaps_lsp").on_attach(client, buffer)
      end)

      require("util.lsp").setup()
      require("util.lsp").on_dynamic_capability(require("keymaps_lsp").on_attach)

      require("util.lsp").words.setup(opts.document_highlight)

      -- diagnostics signs
      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end

      if vim.fn.has("nvim-0.10") == 1 then
        -- inlay hints
        if opts.inlay_hints.enabled then
          require("util.lsp").on_supports_method("textDocument/inlayHint", function(client, buffer)
            if
                vim.api.nvim_buf_is_valid(buffer)
                and vim.bo[buffer].buftype == ""
                and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
            then
              vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
          end)
        end

        -- code lens
        if opts.codelens.enabled and vim.lsp.codelens then
          require("util.lsp").on_supports_method("textDocument/codeLens", function(client, buffer)
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = buffer,
              callback = vim.lsp.codelens.refresh,
            })
          end)
        end
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
            or function(diagnostic)
              for d, icon in pairs(diagnostic_icons) do
                if diagnostic.severity == vim.diagnostic.severity[d] then
                  return icon
                end
              end
            end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
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
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

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

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            require("util.lazy").opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        })
      end

      if require("util.lsp").is_enabled("denols") and require("util.lsp").is_enabled("vtsls") then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        require("util.lsp").disable("vtsls", is_deno)
        require("util.lsp").disable("denols", function(root_dir, config)
          if not is_deno(root_dir) then
            config.settings.deno.enable = false
          end
          return false
        end)
      end
    end,
  },
}
