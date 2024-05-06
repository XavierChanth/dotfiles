-- make lazygit work with git worktrees
return function(opts)
  local LazyVim = require("lazyvim.util")
  local Process = require("lazy.manage.process")

  local gitroot = LazyVim.root.git()
  local cwd = vim.uv.cwd() or gitroot
  if opts.root or false then
    cwd = gitroot
  end

  local isbare = false
  local ok, lines = pcall(Process.exec, { "git", "rev-parse", "--is-bare-repository" }, { cwd = cwd })
  if ok then
    isbare = lines[1] == "true"
  else
    LazyVim.error({ "Failed to determine if this repo is bare, assuming non-bare." })
  end
  if not isbare then
    return LazyVim.lazygit({ cwd = cwd })
  end

  local gitdir = cwd
  ok, lines = pcall(Process.exec, { "git", "rev-parse", "--git-dir" }, { cwd = gitroot })
  if ok then
    gitdir = lines[1]
  else
    LazyVim.error({ "Failed to retrieve git dir." })
  end

  local args = { "--git-dir=" .. gitdir, "-work-tree=" .. cwd }
  return LazyVim.lazygit({ args = args, cwd = cwd })
end
