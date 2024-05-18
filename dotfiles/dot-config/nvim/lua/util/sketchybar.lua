local M = {}
local Job = require("plenary.job")

M.reload_config = function()
  Job:new({
    command = "sketchybar",
    args = { "--reload" },
  }):sync()
end

return M
