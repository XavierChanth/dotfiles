---@class util.dashboard
local M = {}
M.actions = {
  {
    action = function()
      Util.floats.lazygit()
    end,
    desc = " git",
    icon = " ",
    key = "g",
  },
  {
    action = function()
      Util.floats.lazyjj()
    end,
    desc = " jj",
    icon = " ",
    key = "j",
  },
  {
    action = function()
      require("persistence").load()
    end,
    desc = " session",
    icon = " ",
    key = "s",
  },
  {
    action = "qa",
    desc = " quit",
    icon = " ",
    key = "q",
  },
}

for _, button in ipairs(M.actions) do
  button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
  button.key_format = "  %s"
end

return M
