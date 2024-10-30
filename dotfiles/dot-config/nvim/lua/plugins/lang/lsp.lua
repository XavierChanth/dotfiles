local diagnostic_icons = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.HINT] = " ",
  [vim.diagnostic.severity.INFO] = " ",
}
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufReadPre" },
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "mason.nvim" },
        opts = {
          automatic_installation = false,
        },
      },
    },
    opts = {
      diagnostics = {
        update_in_insert = false,
        underline = true,
        virtual_text = {
          spacing = 4,
          prefix = function(diagnostic)
            return diagnostic_icons[diagnostic.severity]
          end,
        },
        severity_sort = true,
      },
      inlay_hints = { enabled = false },
      codelens = { enabled = false },
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
    keys = {
      {
        "<leader>cl",
        "<cmd>LspInfo<cr>",
        desc = "Lsp Info",
      },
    },
    config = function(_, opts)
      -- LSP Attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          -- Default Keymaps
          local map = function(keymap)
            keymap.mode = keymap.mode or "n"
            vim.keymap.set(keymap.mode, keymap[1], keymap[2], { buffer = event.buf, desc = "LSP: " .. keymap.desc })
          end
          map({
            "gd",
            function()
              require("telescope.builtin").lsp_definitions({ reuse_win = true })
            end,
            desc = "Goto Definition",
            has = "definition",
          })
          map({
            "gr",
            function()
              require("telescope.builtin").lsp_references()
            end,
            desc = "References",
          })
          map({
            "gI",
            function()
              require("telescope.builtin").lsp_implementations({ reuse_win = true })
            end,
            desc = "Goto Implementation",
          })
          map({
            "gy",
            function()
              require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
            end,
            desc = "Goto T[y]pe Definition",
          })
          map({
            "gD",
            vim.lsp.buf.declaration,
            desc = "Goto Declaration",
          })
          map({
            "K",
            vim.lsp.buf.hover,
            desc = "Hover",
          })
          map({
            "gK",
            vim.lsp.buf.signature_help,
            desc = "Signature Help",
          })
          map({
            "<c-k>",
            vim.lsp.buf.signature_help,
            mode = "i",
            desc = "Signature Help",
          })
          map({
            "<leader>ca",
            vim.lsp.buf.code_action,
            desc = "Code Action",
            mode = { "n", "v" },
          })
          map({
            "<leader>cr",
            vim.lsp.buf.rename,
            desc = "Rename",
          })
          map({
            "<leader>cA",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Source Action",
          })

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          -- Setup highlight groups when the cursor stops
          if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end
        end,
      })

      -- Setup diagnostic options
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- Merge capabilities from all servers
      local servers = opts.servers
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      -- Setup function for servers
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.attach_server[server] then
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
              local client = vim.lsp.get_client_by_id(event.data.client_id)
              if client and client.name == server then
                if opts.attach_server[server](client, event, server_opts[server]) then
                  return
                end
              end
            end,
          })
        end

        require("lspconfig")[server].setup(server_opts)
      end

      require("mason-lspconfig").setup({
        handlers = { setup },
      })
    end,
  },
}
