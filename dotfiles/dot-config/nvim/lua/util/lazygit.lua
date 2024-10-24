local M = {}

function M.lazygit(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or require("util.root").git(opts)

  local wt = require("util.git_worktree")
  local iswt = wt.is_inside_worktree(opts.cwd)
  if not iswt then
    wt.telescope(opts, function(path, _)
      opts.cwd = path
      require("util.terminal").terminal("lazygit", opts)
    end)
  else
    require("util.terminal").terminal("lazygit", opts)
  end
end

return M
