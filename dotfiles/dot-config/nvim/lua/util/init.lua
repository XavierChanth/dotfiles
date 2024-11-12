---@class util
---@field colorscheme util.colorscheme
---@field dashboard util.dashboard
---@field external util.external
---@field ipynb util.ipynb
---@field lazy util.lazy
---@field lazygit util.lazygit
---@field logo string
---@field platform util.platform
---@field root util.root
---@field statusline util.statusline
---@field telescope util.telescope
---@field terminal util.terminal
---@field vscode util.vscode
---@field worktree util.worktree
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("util." .. k)
    return t[k]
  end,
})
return M
