---@class util.packages
local M = {}

function M.ensure_installed(spec)
  spec = spec or {}
  local lazy_spec = {}
  -- Plugins with an ensure installed tag can concatenated into a single array
  -- which will be the resolved in the final opts
  local ensure_mappings = {
    treesitter = "nvim-treesitter",
    -- conform = "mason-conform",
    -- lsp = "mason-lspconfig.nvim",
    -- lint = "mason-nvim-lint",
  }
  for key, plugin in pairs(ensure_mappings) do
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
        local ok, reg = pcall(require, "mason-registry")
        if ok then
          for _, id in ipairs(spec.mason) do
            local ok2, package = pcall(reg.get_package, id)
            if ok2 then
              local ok3, installed = pcall(package.is_installed, package)
              if ok3 and not installed then
                print("ok3 and not installed")
                pcall(package.install, package)
              end
            end
          end
        end
      end,
    })
  end
  return lazy_spec
end

return M
