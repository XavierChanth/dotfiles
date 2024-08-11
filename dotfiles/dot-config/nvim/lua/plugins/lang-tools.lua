local function get_flutter_bin_path()
  return require("os").getenv("FLUTTER_ROOT") .. "/bin/"
end

-- Additional tools / plugins which enhance / complement LSP
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
    config = {
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
          lineLength = 80,
          -- renameFilesWithClasses = "always",
        },
      },
    },
  },
  {
    "maxandron/goplements.nvim",
    ft = "go",
    opts = {
      -- The prefixes prepended to the type names
      prefix = {
        interface = "implemented by: ",
        struct = "implements: ",
      },
      -- Whether to display the package name along with the type name (i.e., builtins.error vs error)
      display_package = false,
    },
  },
}
