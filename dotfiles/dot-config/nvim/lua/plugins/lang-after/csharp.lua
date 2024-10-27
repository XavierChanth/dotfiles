return {
  -- ft = "cs",
  require("util.lazy").ensure_installed({
    treesitter = { "c_sharp" },
    conform = { "csharpier" },
    lsp = { "omnisharp", "csharp_ls" },
  }),
  {
    "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
      formatters = {
        csharpier = {
          command = "dotnet-csharpier",
          args = { "--write-stdout" },
        },
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = {
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
  -- Additional plugins
  { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
  { "Decodetalkers/csharpls-extended-lsp.nvim" },
}
