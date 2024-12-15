---@class util.packages
local M = {}

function M.ensure_installed(spec)
  spec = spec or {}
  local lazy_spec = {}
  -- Plugins with an ensure installed tag can concatenated into a single array
  -- which will be the resolved in the final opts
  local index = {
    treesitter = "nvim-treesitter",
    conform = "mason-conform",
    lsp = "mason-lspconfig.nvim",
    lint = "mason-nvim-lint",
  }
  for key, plugin in pairs(index) do
    if spec[key] ~= nil then
      lazy_spec[#lazy_spec + 1] = {
        plugin,
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          for _, i in ipairs(spec[key]) do
            table.insert(opts.ensure_installed, i)
          end
          return opts
        end,
      }
    end
  end
  -- Mason doesn't have ensure_installed, so we do it ourselves on VeryLazy
  if spec.mason then
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        local reg = require("mason-registry")
        for _, id in ipairs(spec.mason) do
          local ok, package = pcall(reg.get_package, id)
          if ok and not package:is_installed() then
            package:install()
          end
        end
      end,
    })
  end
  return lazy_spec
end

return M
