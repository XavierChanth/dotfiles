vim.lsp.enable(require("assets/lsp-spec"))

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
local function clear_floats()
  -- TODO
end

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
        clear_floats()
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
        clear_floats()
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
        vim.lsp.buf.hover({
          border = "rounded",
          close_events = {
            "CursorMoved",
            "CursorMovedI",
            "InsertCharPre",
            "BufWinLeave",
          },
        })
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

local configured_lsps = function(arg)
  return vim
    .iter(vim.api.nvim_get_runtime_file(("lsp/%s*.lua"):format(arg), true))
    :map(function(path)
      local file_name = path:match("[^/]*.lua$")
      return file_name:sub(0, #file_name - 4)
    end)
    :totable()
end

local complete_client = function(arg)
    return vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :filter(function(name)
        return name:sub(1, #arg) == arg
      end)
      :totable()
end

vim.api.nvim_create_user_command("LspRestart", function(info)
  local clients = info.fargs

  -- Default to restarting all active servers
  if #clients == 0 then
    clients = vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :totable()
  end

  for _, name in ipairs(clients) do
    if vim.lsp.config[name] == nil then
      vim.notify(("Invalid server name '%s'"):format(name))
    else
      vim.lsp.enable(name, false)
    end
  end

  local timer = assert(vim.uv.new_timer())
  timer:start(500, 0, function()
    for _, name in ipairs(clients) do
      vim.schedule_wrap(function(x)
        vim.lsp.enable(x)
      end)(name)
    end
  end)
end, {
  desc = "Restart the given client",
  nargs = "?",
  complete = configured_lsps,
})
vim.api.nvim_create_user_command("LspStart", function(conf)
  if conf.args ~= "" then
    vim.lsp.enable(conf.args)
  else
    vim.lsp.enable(require("assets/lsp-spec"))
  end
end, {
  nargs = "?",
  complete = configured_lsps,
})

vim.api.nvim_create_user_command('LspStop', function(info)
    local clients = info.fargs

    -- Default to disabling all servers on current buffer
    if #clients == 0 then
      clients = vim
        .iter(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }))
        :map(function(client)
          return client.name
        end)
        :totable()
    end

    for _, name in ipairs(clients) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      else
        vim.lsp.enable(name, false)
      end
    end
  end, {
    desc = 'Disable and stop the given client',
    nargs = '?',
    complete = complete_client,
  })

vim.api.nvim_create_user_command("LspInfo", ":che vim.lsp", {})
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename()))
end, {})
