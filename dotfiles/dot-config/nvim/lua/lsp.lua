vim.lsp.enable({
  "asm_lsp",
  "basedpyright",
  "clangd",
  "csharp_ls",
  "dartls",
  "docker_compose_language_service",
  "docker_ls",
  "gopls",
  "jsonls",
  "lua_ls",
  "neocmake",
  "omnisharp",
  "rubocop",
  "rubyls",
  "ruff",
  "rust_analyzer",
  "sourcekit",
  "svelte",
  "tailwindcss",
  "tinymist",
  "vtsls",
  "yamlls",
  "zls",
})

vim.api.nvim_create_user_command(
  "LspInfo",
  ":che vim.lsp",
  { desc = "Show LspInfo" }
)
vim.api.nvim_create_user_command("LspRestart", function(_)
  vim.lsp.stop_client(vim.lsp.get_clients())
  vim.schedule_wrap_fn(vim.cmd)("edit")
end, {})

vim.lsp.config("*", {
  capabilities = {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  },
  root_markers = { ".git", ".jj" },
})

vim.keymap.set("n", "<leader>cd", function()
  vim.diagnostic.open_float({
    border = "rounded",
  })
end, {})

vim.lsp.inlay_hint.enable(false)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    -- Default Keymaps
    local map = function(keymap)
      keymap.mode = keymap.mode or "n"
      vim.keymap.set(
        keymap.mode,
        keymap[1],
        keymap[2],
        { buffer = event.buf, desc = "LSP: " .. keymap.desc }
      )
    end
    map({
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
      has = "definition",
    })
    map({
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "References",
    })
    map({
      "gI",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    })
    map({
      "gy",
      function()
        Snacks.picker.lsp_type_definitions()
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
      function()
        vim.lsp.buf.hover({ border = "rounded" })
      end,
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
      "<leader>a",
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
    if
      client:supports_method(
        vim.lsp.protocol.Methods.textDocument_documentHighlight
      )
    then
      local highlight_augroup =
        vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
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
          vim.api.nvim_clear_autocmds({
            group = "lsp-highlight",
            buffer = event2.buf,
          })
        end,
      })
    end
  end,
})
