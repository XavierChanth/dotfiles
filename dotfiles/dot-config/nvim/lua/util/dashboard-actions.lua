local actions = {
  {
    action = LazyVim.telescope("files"),
    desc = " Find File",
    icon = " ",
    key = "f",
  },
  {
    action = 'lua require("util.git").worktrees()',
    desc = " Worktrees",
    icon = " ",
    key = "w",
  },
  {
    action = 'lua require("util.git").worktreeAdd()',
    desc = " Worktree Add",
    icon = " ",
    key = "a",
  },

  {
    action = "lua LazyVim.lazygit()",
    desc = " Lazygit",
    icon = " ",
    key = "g",
  },
  {
    action = 'lua require("persistence").load()',
    desc = " Restore Session",
    icon = " ",
    key = "s",
  },
  {
    action = "Lazy",
    desc = " Lazy",
    icon = "󰒲 ",
    key = "l",
  },
  {
    action = "LazyExtras",
    desc = " Lazy Extras",
    icon = " ",
    key = "x",
  },
  {
    action = "lua LazyVim.telescope.config_files()()",
    desc = " Config",
    icon = " ",
    key = "c",
  },
  {
    action = "qa",
    desc = " Quit",
    icon = " ",
    key = "q",
  },
}
for _, button in ipairs(actions) do
  button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
  button.key_format = "  %s"
end

return actions
