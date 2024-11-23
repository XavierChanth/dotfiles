---@class util.floats
local M = {}

function M.lazygit(_, opts)
  opts = opts or {}
  opts.cwd = opts.cwd or Util.root.git(opts)

  local iswt = Util.worktree.is_inside(opts.cwd)
  if not iswt then
    require("arbor").pick({
      show_actions = false,
      preserve_default_hooks = false,
      hooks = {
        pre = function() end,
        ---@param info arbor.git.info
        post = function(info)
          opts.cwd = info.branch_info.worktree_path
          Util.terminal("lazygit", opts)
        end,
      },
    })
  else
    Util.terminal("lazygit", opts)
  end
end

function M.lazyjj(_, opts)
  opts = opts or {}
  opts.cwd = opts.cwd or Util.root.git(opts)
  Util.terminal("lazyjj", opts)
end

return M
