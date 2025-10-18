return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    ".git",
  },
  single_file_support = true,
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = {
    settings = {
      logLevel = "error",
    },
  },
  settings = {},
  on_attach = function(client, buf)
    vim.api.nvim_buf_set_var(buf, "shiftwidth", 4)
    vim.api.nvim_buf_set_var(buf, "tabstop", 4)
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end,
}
