local M = {}
local Job = require("plenary.job")

M.reload_config = function()
  if require("util.platform").is_macos() then
    Job:new({
      command = "sketchybar",
      args = { "--reload" },
    }):sync()
  end
end

return M
