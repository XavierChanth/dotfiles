---@class util.lazygit
local M = {}

setmetatable(M, {
  __call = function(_, opts)
    opts = opts or {}
    opts.cwd = opts.cwd or Util.root.git(opts)

    local iswt = Util.worktree.is_inside(opts.cwd)
    if not iswt then
      Util.worktree.telescope(opts, function(path, _)
        opts.cwd = path
        Util.terminal("lazygit", opts)
      end)
    else
      Util.terminal("lazygit", opts)
    end
  end,
})
return M
