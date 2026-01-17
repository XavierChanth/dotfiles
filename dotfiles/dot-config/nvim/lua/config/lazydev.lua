P("ldev startup")
require("lazydev").setup({
  enabled = function(root_dir)
    P("ldev root: " .. root_dir)
    return root_dir == vim.fn.stdpath("config")
  end,
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    { path = "snacks.nvim", words = { "Snacks" } },
  },
})


