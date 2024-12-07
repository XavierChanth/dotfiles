---@class util
---@field ansi_colors util.ansi_colors
---@field colorscheme util.colorscheme
---@field floats util.floats
---@field git util.git
---@field ipynb util.ipynb
---@field jj util.jj
---@field lazy util.lazy
---@field logo string
---@field packages util.packages
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
