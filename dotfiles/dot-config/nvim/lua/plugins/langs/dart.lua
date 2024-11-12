local flutter_root = require("os").getenv("FLUTTER_ROOT")
if not flutter_root then
  vim.notify("FLUTTER_ROOT not set", vim.log.levels.WARN)
end

return {
  Util.lazy.ensure_installed({
    treesitter = { "dart" },
  }),
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        dartls = {
          root_dir = function(_)
            local roots = Util.root.detect({
              all = false,
              spec = { ".git", "melos.yaml", "pubspec.yaml" },
            })
            return roots[1] and roots[1].paths[1] or vim.uv.cwd()
          end,
          init_options = {
            onlyAnalyzeProjectsWithOpenFiles = true,
            suggestFromUnimportedLibraries = true,
            closingLabels = true,
            outline = true,
            flutterOutline = true,
          },
          settings = {
            dart = {
              analysisExcludedFolders = {},
              lineLength = 80,
              completeFunctionCalls = true,
              showTodos = false,
              renameFilesWithClasses = "prompt",
              enableSnippets = false,
              updateImportsOnRename = true,
              includeDependenciesInWorkspaceSymbol = false,
            },
          },
        },
      },
      attach_server = {
        dartls = function(client)
          client.config.settings.dart.lineLength = 80

          -- Detect if this package is published, if not, set line length to 120
          local pubspec_file = client.config.root_dir .. "/pubspec.yaml"
          local file = io.open(pubspec_file, "r")
          if file ~= nil then
            ---@type string | nil
            local line = ""
            while line do
              line = file:read("*L")
              if line ~= nil then
                local _, pos = line:find("publish_to:", 1, true)
                if pos ~= nil then
                  if line:find("['\"%s]?none['\"%s]", pos) ~= nil then
                    client.config.settings.dart.lineLength = 120
                  end
                  line = nil
                end
              end
            end
            file:close()
          end

          if flutter_root then
            client.config.settings.dart.analysisExcludedFolders = {
              flutter_root .. "/packages",
              Util.platform.home .. "/.pub-cache",
            }
          else
            client.config.settings.dart.analysisExcludedFolders = {
              Util.platform.home .. "/.pub-cache",
            }
          end

          -- notify the client of the
          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end,
      },
    },
  },
  -- Additional plugins
  {
    "wa11breaker/flutter-bloc.nvim",
    event = "BufReadPre *.dart,pubspec.yaml",
  },
}
