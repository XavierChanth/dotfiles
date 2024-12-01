-- These utilities are from LazyVim's utility library
-- Super useful and made it easier to migrate by keeping these in place
---@class util.lazy: LazyUtilCore
local M = {}

local LazyUtil = nil
setmetatable(M, {
  __index = function(_, k)
    if not LazyUtil then
      LazyUtil = require("lazy.core.util")
    end
    if LazyUtil[k] then
      return LazyUtil[k]
    end
  end,
})

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

---@return LazyFloat
function M.float_term(...)
  return require("lazy.util").float_term(...)
end

return M
