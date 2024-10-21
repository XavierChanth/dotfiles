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
        init_options = {
          onlyAnalyzeProjectsWithOpenFiles = false,
          closingLabels = true,
        },
        on_attach = function(client)
          client.config.settings.dart.lineLength = 80

          local pubspec_file = client.config.root_dir .. "/pubspec.yaml"
          local file = io.open(pubspec_file, "r")
          if file ~= nil then
            local line = ""
            while line ~= nil do
              line = file:read("*L")
              if line ~= nil then
                local _, pos = line:find("publish_to:", 1, true)
                if pos ~= nil then
                  if line:find("['\"%s]?none['\"%s]", pos) ~= nil then
                    client.config.settings.dart.lineLength = 120
                  end
                  ---@diagnostic disable-next-line: cast-local-type
                  line = nil
                end
              end
            end
            file:close()
          end

          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end,
        settings = {
          dart = {
            lineLength = 80,
          },
        },
      },
    },
  },
  {
    "wa11breaker/flutter-bloc.nvim",
    event = "BufReadPre *.dart,pubspec.yaml",
  },
}
