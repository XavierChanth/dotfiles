return {
  cmd = { "csharp-ls" },
  root_dir = function(bufnr, cb)
    cb(vim.fs.root(bufnr, function(name, _)
      return name:match("%.csproj$") ~= nil
    end))
  end,
  filetypes = { "cs" },

  init_options = {
    AutomaticWorkspaceInit = true,
  },
  handlers = {
    ["textDocument/definition"] = function(...)
      require("csharpls_extended").handler(...)
    end,
    ["textDocument/typeDefinition"] = function(...)
      require("csharpls_extended").handler(...)
    end,
  },
}
