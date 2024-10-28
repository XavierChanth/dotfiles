local M = {}
M.actions = {
  {
    action = function()
      require("util.git_worktree").telescope()
    end,
    desc = " Worktrees",
    icon = " ",
    key = "w",
  },
  {
    action = function()
      require("util.git_worktree").add()
    end,
    desc = " Worktree Add",
    icon = " ",
    key = "a",
  },
  {
    action = function()
      require("util.lazygit").lazygit()
    end,
    desc = " Lazygit",
    icon = " ",
    key = "g",
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
