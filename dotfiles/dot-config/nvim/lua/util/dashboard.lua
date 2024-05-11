local M = {}
M.actions = {
  {
    action = LazyVim.telescope("files"),
    desc = " Find File",
    icon = " ",
    key = "f",
  },
  {
    action = 'lua require("util.git_worktree").telescope()',
    desc = " Worktrees",
    icon = " ",
    key = "w",
  },
  {
    action = 'lua require("util.git_worktree").add()',
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
    action = function()
      return require("lazyvim.util.telescope").telescope("files", {
        cwd = vim.fn.expand("$HOME/.dotfiles"),
        show_untracked = true,
        git_command = { "/bin/zsh", "-c", "git ls-files --exclude-standard --cached" },
      })
    end,
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
for _, button in ipairs(M.actions) do
  button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
  button.key_format = "  %s"
end

return M
