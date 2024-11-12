package.path = Util.platform.home .. "/.local/state/colorscheme/colorscheme.lua;" .. package.path

---@class util.colorscheme
local M = {}

local timer = vim.uv.new_timer()

local function try_switch()
  package.loaded["colorscheme"] = nil
  local theme = require("colorscheme")
  if theme ~= vim.g.colors_name then
    vim.cmd.colorscheme(theme)
  end
end

function M.get()
  return require("colorscheme")
end

function M.start_timer(time)
  if timer ~= nil then
    timer:start(0, time, vim.schedule_wrap(try_switch))
  end
end

return M
