---@class util.floats
local M = {}

function M.lazygit(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or Util.root.git(opts)
  Util.terminal("lazygit", opts)
end

function M.lazyjj(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or Util.root.git(opts)
  Util.terminal("lazyjj", opts)
end

return M
