---Floating windows that I want embedded in my workflow
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
  -- opts.env = opts.env or {}
  -- opts.env["JJ_EDITOR"] = "nvim --remote-tab"
  Util.terminal("lazyjj", opts)
end

return M
