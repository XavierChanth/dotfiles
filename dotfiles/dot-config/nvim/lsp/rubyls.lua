return {
  cmd = { "ruby-lsp" },
  filetypes = { "ruby", "eruby" },
  root_markers = {
    "Gemfile",
    ".git",
  },
  single_file_support = true,
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = {
    formatter = "auto",
  },
}
