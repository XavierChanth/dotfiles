---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".emmyrc.json",
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  root_dir = function(buf, on_dir)
    -- attach to existing workspace if possible
    local ws = require("lazydev").find_workspace(buf)
    if ws ~= nil then
      return on_dir(ws)
    end

    -- use ~/.config/nvim for everything nvim-related as that seems to work best
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if
      vim.fs.relpath(vim.fn.stdpath("config"), buf_name)
      or vim.fs.relpath(vim.fn.stdpath("data"), buf_name)
      or vim.fs.relpath(vim.env.VIMRUNTIME, buf_name)
    then
      return on_dir(vim.fn.stdpath("config"))
    end

    -- fallback to default (luarc, git, …)
    return on_dir(nil)
  end,
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      codeLens = { enable = true },
      hint = { enable = true, semicolon = "Disable" },
    },
  },
}
