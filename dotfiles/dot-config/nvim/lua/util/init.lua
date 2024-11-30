---@class util
---@field colorscheme util.colorscheme
---@field dashboard util.dashboard
---@field ipynb util.ipynb
---@field lazy util.lazy
---@field floats util.floats
---@field logo string
---@field platform util.platform
---@field root util.root
---@field statusline util.statusline
---@field terminal util.terminal
---@field tmux util.tmux
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("util." .. k)
    return t[k]
  end,
})
return M
