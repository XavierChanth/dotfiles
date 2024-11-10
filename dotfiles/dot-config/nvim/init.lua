---@alias P function
P = function(...)
  vim.print(vim.inspect(...))
end
_G.P = P

_G.Util = require("util")
vim.uv = vim.uv or vim.loop

require("init")
