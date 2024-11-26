---@class util.worktree
local M = {}

---@param info arbor.git.info
function M.arbor_set_dashboard(info)
  info = info or {}
  local worktree = info.new_path or info.branch_info and info.branch_info.display_name or info.cwd or vim.fn.getcwd()
  worktree = string.gsub(worktree, info.resolved_base .. "/", "")
  worktree = string.gsub(worktree, info.resolved_base, "")
  vim.schedule(function()
    vim.cmd("Dashboard")
  end)
  vim.defer_fn(function()
    vim.cmd({ cmd = "DashboardUpdateFooter", args = { "Worktree: " .. worktree } })
  end, 20)
end

local function is_valid_switch(info)
  return not (info.repo_type ~= "bare" and info.cwd == info.resolved_base and info.cwd == info.branch_info.new_path)
end

function M.arbor_save(info)
  if is_valid_switch(info) then
    require("persistence").save()
  end
end

function M.arbor_pre_add(info)
  M.arbor_save(info)
end

function M.arbor_post_add(info)
  info = require("arbor").actions.set_upstream(info) or info
  M.arbor_post_switch(info)
end

function M.arbor_pre_switch(info)
  if is_valid_switch(info) then
    M.arbor_save(info)
  end
end

function M.arbor_post_switch(info)
  if is_valid_switch(info) then
    if info.new_path then
      require("arbor").actions.cd_new_path(info)
    else
      require("arbor").actions.cd_existing_worktree(info)
    end
    vim.cmd("bufdo bd")
    M.arbor_set_dashboard(info)
  else
    vim.notify("Already on this worktree")
  end
end

function M.arbor_pre_remove(info)
  require("arbor").actions.pick_if_current(info, {})
end

function M.is_inside(path)
  return require("arbor").git.is_inside_worktree(path)
end

return M
