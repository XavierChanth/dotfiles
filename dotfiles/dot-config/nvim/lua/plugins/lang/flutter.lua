local function get_flutter_bin_path()
  return require("os").getenv("FLUTTER_ROOT") .. "/bin/"
end

return {
  {
    "akinsho/flutter-tools.nvim",
    event = "BufReadPre *.dart,pubspec.yaml",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>rf",
        function()
          require("telescope").extensions.flutter.commands()
        end,
        desc = "Flutter Commands",
      },
    },
    opts = {
      flutter_path = get_flutter_bin_path() .. "flutter",
      lsp = {
        root_dir = function()
          return vim.uv.cwd()
        end,
        init_options = {
          onlyAnalyzeProjectsWithOpenFiles = false,
          closingLabels = true,
        },
        settings = {
          lineLength = 80, -- renameFilesWithClasses = "always",
        },
      },
    },
  },
  {
    "wa11breaker/flutter-bloc.nvim",
    event = "BufReadPre *.dart,pubspec.yaml",
  },
}
