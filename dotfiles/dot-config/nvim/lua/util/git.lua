---@class util.git
local M = {}

function M.open(opts)
  opts = opts or {}
  local cwd = opts.cwd or Util.root.git()
  local iswt = Util.worktree.is_inside(cwd)
  if not iswt then
    require("arbor").pick({
      show_actions = false,
      preserve_default_hooks = false,
      hooks = {
        pre = function() end,
        ---@param info arbor.git.info
        post = function(info)
          require("neogit").open({
            cwd = info.branch_info.worktree_path,
          })
        end,
      },
    })
  else
    require("neogit").open({ cwd = cwd })
  end
end

return M
