-- From LazyVim
local M = {}

M._keys = nil

function M.get()
  if M._keys then
    return M._keys
  end
  -- stylua: ignore
  M._keys = {
    { "<leader>cl", "<cmd>LspInfo<cr>",                                                                     desc = "Lsp Info" },
    { "gd",         function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,      desc = "Goto Definition",            has = "definition" },
    { "gr",         "<cmd>Telescope lsp_references<cr>",                                                    desc = "References",                 nowait = true },
    { "gI",         function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end,  desc = "Goto Implementation" },
    { "gy",         function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
    { "gD",         vim.lsp.buf.declaration,                                                                desc = "Goto Declaration" },
    { "K",          vim.lsp.buf.hover,                                                                      desc = "Hover" },
    { "gK",         vim.lsp.buf.signature_help,                                                             desc = "Signature Help",             has = "signatureHelp" },
    { "<c-k>",      vim.lsp.buf.signature_help,                                                             mode = "i",                          desc = "Signature Help", has = "signatureHelp" },
    { "<leader>ca", vim.lsp.buf.code_action,                                                                desc = "Code Action",                mode = { "n", "v" },     has = "codeAction" },
    { "<leader>cc", vim.lsp.codelens.run,                                                                   desc = "Run Codelens",               mode = { "n", "v" },     has = "codeLens" },
    { "<leader>cC", vim.lsp.codelens.refresh,                                                               desc = "Refresh & Display Codelens", mode = { "n" },          has = "codeLens" },
    { "<leader>cR", require("util.lsp").rename_file,                                                        desc = "Rename File",                mode = { "n" },          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
    { "<leader>cr", vim.lsp.buf.rename,                                                                     desc = "Rename",                     has = "rename" },
    { "<leader>cA", require("util.lsp").action.source,                                                      desc = "Source Action",              has = "codeAction" },
    {
      "]]",
      function() require("util.lsp").words.jump(vim.v.count1) end,
      has = "documentHighlight",
      desc = "Next Reference",
      cond = function() return require("util.lsp").words.enabled end
    },
    {
      "[[",
      function() require("util.lsp").words.jump(-vim.v.count1) end,
      has = "documentHighlight",
      desc = "Prev Reference",
      cond = function() return require("util.lsp").words.enabled end
    },
    {
      "<a-n>",
      function() require("util.lsp").words.jump(vim.v.count1, true) end,
      has = "documentHighlight",
      desc = "Next Reference",
      cond = function() return require("util.lsp").words.enabled end
    },
    {
      "<a-p>",
      function() require("util.lsp").words.jump(-vim.v.count1, true) end,
      has = "documentHighlight",
      desc = "Prev Reference",
      cond = function() return require("util.lsp").words.enabled end
    },
  }

  return M._keys
end

---@param method string|string[]
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find("/") and method or "textDocument/" .. method
  local clients = require("util.lsp").get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = M.get()
  local opts = require("util.lazy").opts("nvim-lspconfig")
  local clients = require("util.lsp").get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local lazy_keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = lazy_keys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
