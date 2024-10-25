-- These utilities are from LazyVim's utility library
-- Super useful and made it easier to migrate by keeping these in place
local M = {}
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

function M.has(name)
  return M.get_plugin(name) ~= nil
end

function M.is_loaded(name)
  local plugin = M.get_plugin(name)
  return plugin and plugin._.loaded
end

function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

local cache = {} ---@type table<(fun()), table<string, any>>
---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
  return function(...)
    local key = vim.inspect({ ... })
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then
      cache[fn][key] = fn(...)
    end
    return cache[fn][key]
  end
end

local LazyUtil = require("lazy.core.util")

function M.ensure_installed(spec)
  spec = spec or {}
  local lazy_spec = {}
  local index = {
    treesitter = "nvim-treesitter",
    conform = "mason-conform",
    lsp = "mason-lspconfig.nvim",
    lint = "mason-nvim-lint",
  }
  for key, plugin in pairs(index) do
    if spec[key] ~= nil then
      lazy_spec[#lazy_spec+1] = {
        plugin,
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          for _, i in ipairs(spec[key]) do
            table.insert(opts.ensure_installed, i)
          end
          return opts
        end
      }
    end
  end
  return lazy_spec
end



setmetatable(M, {
  __index = function(_, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
  end,
})

return M
