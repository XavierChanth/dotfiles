---@class util.ansi_colors
local M = {}

local baleia = nil
function M.baleia()
  baleia = baleia or require("baleia").setup({})
  return baleia
end

return M
