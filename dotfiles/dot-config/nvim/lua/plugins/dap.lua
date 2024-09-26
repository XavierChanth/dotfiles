return {
  "jay-babu/mason-nvim-dap.nvim",
  config = function() -- make codelldb show up as lldb so it plays nice with vscode config
    local ft = require("mason-nvim-dap.mappings.filetypes")
    ft.lldb = ft.codelldb
    local dap = require("dap")
    dap.adapters.lldb = require("mason-nvim-dap.mappings.adapters.codelldb")
    require("util.dotenv").load(vim.fs.find(".env", { type = "file", root_dir = require("util.root").git() })[1])
  end,
}
