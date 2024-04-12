local onlyAnalyzeProjectsWithOpenFiles = false
return {
  {
    "akinsho/flutter-tools.nvim",
    event = "BufReadPre *.dart,pubspec.yaml",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = {
      flutter_lookup_cmd = "asdf where flutter",
      lsp = {
        root_dir = function()
          return vim.loop.cwd()
        end,
        init_options = {
          onlyAnalyzeProjectsWithOpenFiles = onlyAnalyzeProjectsWithOpenFiles,
          closingLabels = true,
        },
        settings = {
          lineLength = 120,
          -- renameFilesWithClasses = "always",
        },
      },
    },
  },
}
