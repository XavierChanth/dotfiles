---@class util.dashboard
local M = {}
M.actions = {
  {
    action = function()
      require("arbor").pick()
    end,
    desc = " Worktrees",
    icon = " ",
    key = "w",
  },
  {
    action = function()
      require("arbor").add()
    end,
    desc = " Worktree Add",
    icon = " ",
    key = "a",
  },
  {
    action = function()
      Util.git.open()
    end,
    desc = " Neogit",
    icon = " ",
    key = "g",
  },
  {
    action = function()
      Util.floats.lazyjj()
    end,
    desc = " LazyJJ",
    icon = " ",
    key = "j",
  },
  {
    action = function()
      require("persistence").load()
    end,
    desc = " Restore Session",
    icon = " ",
    key = "s",
  },
  {
    action = "qa",
    desc = " Quit",
    icon = " ",
    key = "q",
  },
}

for _, button in ipairs(M.actions) do
  button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
  button.key_format = "  %s"
end

return M
