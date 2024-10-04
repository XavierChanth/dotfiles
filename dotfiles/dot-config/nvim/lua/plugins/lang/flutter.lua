local os = require("os")
local flutter_root = os.getenv("FLUTTER_ROOT")
if not flutter_root then
  return {}
end

local flutter_path = flutter_root .. "/bin/flutter"
local flutter_exists = vim.uv.fs_stat(flutter_path) or false

if not flutter_exists then
  return {}
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
      flutter_path = flutter_path,
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
