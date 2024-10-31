local cache = {}

return {
  Util.lazy.ensure_installed({
    treesitter = { "dart" },
  }),
  -- Additional plugins
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
      closing_tags = { highlight = "Comment", prefix = "󰘟 " },
      dev_log = { open_cmd = "12split" },
      root_pattern = { ".git" },
      lsp = {
        init_options = {
          onlyAnalyzeProjectsWithOpenFiles = false,
        },
        on_attach = function(client)
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

          client.config.settings.dart.analysisExcludedFolders = {
            cache.flutter_root .. "/packages",
            -- cache.flutter_root .. "/.pub-cache",
          }
          -- notify the client of the
          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end,
        settings = {
          dart = {
            lineLength = 80,
          },
        },
      },
    },
    config = function(_, opts)
      cache.flutter_root = require("os").getenv("FLUTTER_ROOT")
      if cache.flutter_root then
        cache.flutter_path = cache.flutter_root .. "/bin/flutter"
      else
        vim.notify("FLUTTER_ROOT not set", vim.log.levels.WARN)
      end
      require("flutter-tools").setup(vim.tbl_deep_extend("force", {
        flutter_path = cache.flutter_path,
      }, opts))
      require("telescope").load_extension("flutter")
    end,
  },
  {
    "wa11breaker/flutter-bloc.nvim",
    event = "BufReadPre *.dart,pubspec.yaml",
  },
}
