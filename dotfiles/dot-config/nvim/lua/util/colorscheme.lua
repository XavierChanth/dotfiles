local timer = vim.uv.new_timer()
local prev_color = nil

local function apply()
  local theme = require("last-color").recall() or prev_color or "catppuccin-mocha"
  if prev_color ~= theme then
    vim.cmd(("colorscheme %s"):format(theme))
    prev_color = theme
  end
end

local function start_timer()
  if timer ~= nil then
    timer:start(0, 5000, vim.schedule_wrap(apply)) -- every 5 secs
  end
end

return {
  setup = function()
    apply()
    start_timer()
  end,
}
