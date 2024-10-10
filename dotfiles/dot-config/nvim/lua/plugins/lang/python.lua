-- Bro this looks weird, but this is the only way to use ruff without pyright
-- with LazyVim... and I'm lazy so this is what we live with
-- Honestly... the python extra looks like two PRs were both opened and merged
-- at around the same time, these options make no sense relative to eachother
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

return {
  { import = "lazyvim.plugins.extras.lang.python" },
}
