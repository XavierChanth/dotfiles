M = {}

function M.lazygit(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or require("util.root").git(opts)

  local wt = require("util.git_worktree")
  local iswt = wt.is_inside_worktree(opts.cwd)
  if not iswt then
    wt.telescope(vim.tbl_deep_extend("force", {
      attach_mappings = function(_, _)
        local actions = require("telescope.actions")
        actions.select_default:enhance({
          pre = function()
            wt.one_shot_cb(function()
              opts.cwd = require("util.root").git(opts)
              LazyVim.lazygit(opts)
            end)
          end,
        })
        return true
      end,
    }, opts))
  else
    LazyVim.lazygit(opts)
  end
end

return M
