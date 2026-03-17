-- local flutter_root = nil
--
-- local lsp_global_root_mode = false

---@type vim.lsp.Config
return {
  cmd = { 'dart', 'language-server', '--protocol=lsp' },
  filetypes = { 'dart' },
  root_markers = { 'pubspec.yaml' },
  init_options = {
    onlyAnalyzeProjectsWithOpenFiles = true,
    suggestFromUnimportedLibraries = true,
    closingLabels = true,
    outline = true,
    flutterOutline = true,
  },
  settings = {
    dart = {
      completeFunctionCalls = true,
      showTodos = true,
    },
  },
}

---@type vim.lsp.Config
-- return {
-- 	cmd = { "dart", "language-server", "--protocol=lsp" },
-- 	filetypes = { "dart", "pubspec" },
-- 	root_markers = { "pubspec.yaml" },
-- 	init_options = {
-- 		closingLabels = true,
-- 		flutterOutline = true,
-- 		onlyAnalyzeProjectsWithOpenFiles = false,
-- 		outline = true,
-- 		suggestFromUnimportedLibraries = true,
-- 	},
-- 	reuse_client = function(client, config)
-- 		return true
-- 		-- if config.root_dir:find(".pub-cache") or config.root_dir:find(".local/dev/flutter/") then
-- 		--   config.root_dir = client.root_dir
-- 		--   return true
-- 		-- end
-- 		-- return config.root_dir == client.root_dir
-- 	end,
--
-- 	settings = {
-- 		dart = {
-- 			allowAnalytics = false,
-- 			analysisExcludedFolders = {},
-- 			lineLength = 80,
-- 			completeFunctionCalls = true,
-- 			showTodos = false,
-- 			renameFilesWithClasses = "prompt",
-- 			enableSnippets = false,
-- 			updateImportsOnRename = true,
-- 			includeDependenciesInWorkspaceSymbol = false,
-- 		},
-- 	},
--
-- 	-- on_attach = function(client, buf)
-- 	--   -- vim.keymap.set("n", "<leader>ct", function()
-- 	--   --   local mode
-- 	--   --   if lsp_global_root_mode then
-- 	--   --     mode = "package"
-- 	--   --   else
-- 	--   --     mode = "workspace"
-- 	--   --   end
-- 	--   --   lsp_global_root_mode = not lsp_global_root_mode
-- 	--   --   vim.notify("Toggled root mode to: " .. mode)
-- 	--   --   vim.cmd("LspRestart")
-- 	--   -- end, {
-- 	--   --   buffer = buf,
-- 	--   --   desc = "DartLS toggle root mode",
-- 	--   -- })
-- 	--
-- 	--   -- Detect if this package is published, if not, set line length to 120
-- 	--   -- if client and client.config and client.config.root_dir then
-- 	--   -- client.config.settings.dart.lineLength = 80
-- 	--   --   local pubspec_file = client.config.root_dir .. "/pubspec.yaml"
-- 	--   --   local file = io.open(pubspec_file, "r")
-- 	--   --   if file ~= nil then
-- 	--   --     ---@type string | nil
-- 	--   --     local line = ""
-- 	--   --     while line do
-- 	--   --       line = file:read("*L")
-- 	--   --       if line ~= nil then
-- 	--   --         local _, pos = line:find("publish_to:", 1, true)
-- 	--   --         if pos ~= nil then
-- 	--   --           if line:find("['\"%s]?none['\"%s]", pos) ~= nil then
-- 	--   --             client.config.settings.dart.lineLength = 120
-- 	--   --           end
-- 	--   --           line = nil
-- 	--   --         end
-- 	--   --       end
-- 	--   --     end
-- 	--   --     file:close()
-- 	--   --   end
-- 	--   -- end
-- 	--
-- 	--   -- if not flutter_root then
-- 	--   --   flutter_root = require("os").getenv("FLUTTER_ROOT")
-- 	--   --   if not flutter_root then
-- 	--   --     vim.notify("FLUTTER_ROOT not set", vim.log.levels.WARN)
-- 	--   --   end
-- 	--   -- end
-- 	--   --
-- 	--   -- if flutter_root then
-- 	--   --   client.config.settings.dart.analysisExcludedFolders = {
-- 	--   --     flutter_root .. "/packages",
-- 	--   --     require("platform").home .. "/.pub-cache",
-- 	--   --   }
-- 	--   -- else
-- 	--   --   client.config.settings.dart.analysisExcludedFolders = {
-- 	--   --     require("platform").home .. "/.pub-cache",
-- 	--   --   }
-- 	--   -- end
-- 	--
-- 	--   -- notify the client of the
-- 	--   client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
-- 	-- end,
-- }
