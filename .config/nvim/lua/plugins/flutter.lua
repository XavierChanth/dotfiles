local onlyAnalyzeProjectsWithOpenFiles = false
return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = {
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
        on_attach = function()
          local session = require("persistence").get_current()
          local is_atmono, _ = session:find("at_mono")
          -- at_mono is a BIG project, so we don't want to analyze the whole thing
          onlyAnalyzeProjectsWithOpenFiles = (is_atmono > 0 and true or false)
          -- Lazy way to add workspace folder
          vim.lsp.buf.add_workspace_folder(vim.loop.cwd())
          -- Alternatively, add all root patterns as workspace folders
          -- local conf = require("flutter-tools.config")
          -- local path = vim.loop.cwd()
          -- local ws_roots = vim.fs.find(conf.root_patterns, { path = path, limit = 25 })
          --   for _, v in pairs(ws_roots) do
          --     local old_print = print
          --     print = function() end
          --     vim.lsp.buf.add_workspace_folder(vim.fs.dirname(v))
          --     print = old_print
          -- end
        end,
      },
    },
  },
}
