M = {}

function M.lazygit(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or require("util.root").git(opts)

  local wt = require("util.git_worktree")
  local iswt = wt.is_inside_worktree(opts.cwd)
  if not iswt then
    wt.telescope(vim.tbl_deep_extend("force", {
      attach_mappings = function(prompt_bufnr, _)
        local actions = require("telescope.actions")
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          LazyVim.lazygit(vim.tbl_deep_extend("force", opts, {
            cwd = require("telescope.actions.state").get_selected_entry().path,
          }))
        end)
        return true
      end,
    }, opts))
  else
    LazyVim.lazygit(opts)
  end
end

return M
