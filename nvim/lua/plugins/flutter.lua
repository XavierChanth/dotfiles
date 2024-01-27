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
          onlyAnalyzeProjectsWithOpenFiles = false,
        },
        settings = {
          -- renameFilesWithClasses = "always",
        },
        on_attach = function()
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
