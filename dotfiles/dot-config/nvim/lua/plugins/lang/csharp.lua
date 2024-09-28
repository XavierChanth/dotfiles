return {
  { import = "lazyvim.plugins.extras.lang.omnisharp" },
  { "Decodetalkers/csharpls-extended-lsp.nvim" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = {
          keys = { { "gd", false } }, -- disable the LazyVim extra binding
          settings = {
            MsBuild = { LoadProjectsOnDemand = false },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
              AnalyzeOpenDocumentsOnly = false,
            },
            Sdk = { IncludePrereleases = false },
          },
        },
        csharp_ls = {
          handlers = {
            ["textDocument/definition"] = function(...)
              require("csharpls_extended").handler(...)
            end,
            ["textDocument/typeDefinition"] = function(...)
              require("csharpls_extended").handler(...)
            end,
          },
        },
      },
    },
  },
}
