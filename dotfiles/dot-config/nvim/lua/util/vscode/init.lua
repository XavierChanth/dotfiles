---@class util.vscode
---@field keymaps util.vscode.keymaps
---@field settings util.vscode.settings
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("util.vscode." .. k)
    return t[k]
  end,
})

return M
