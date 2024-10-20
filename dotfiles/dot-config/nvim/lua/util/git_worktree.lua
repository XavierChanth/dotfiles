local M = {}

local function set_current(path)
  local base = require("util.root").git({ bare = true })
  local c = string.gsub(path, base .. "/", "")
  if c == "" then
    c = "--"
  end
  vim.cmd("Dashboard")
  vim.defer_fn(function()
    vim.cmd({ cmd = "DashboardUpdateFooter", args = { "Worktree: " .. c } })
  end, 10)
end

-- Simpler flow for git wt add - automatically names the wt to match the branch name
-- TODO: checkout remote branch instead of current branch
function M.add(opts)
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")
  opts = opts or {}
  opts.attach_mappings = function()
    actions.select_default:replace(function(prompt_bufnr, _)
      local selected_entry = actions_state.get_selected_entry()
      local current_line = actions_state.get_current_line()

      actions.close(prompt_bufnr)

      local branch = selected_entry ~= nil and selected_entry.value or current_line

      if branch == nil then
        return
      end

      local name = branch:gsub("^origin/", "", 1)
      local git_root = require("util.root").git({ bare = true })
      local path = git_root .. "/" .. name

      require("plenary.job")
        :new({
          command = "git",
          args = { "branch", name, branch },
          cwd = vim.uv.cwd(),
        })
        :after(function()
          vim.schedule(function()
            require("git-worktree").create_worktree(path, name)
          end)
        end)
        :start()
    end)

    return true
  end

  require("telescope.builtin").git_branches(opts)
end

function M.is_inside_worktree(path)
  local Job = require("plenary.job")

  local res, exit_code = Job:new({
    command = "git",
    args = { "rev-parse", "--is-inside-work-tree" },
    cwd = path,
    enabled_recording = true,
  }):sync()

  return exit_code == 0 and res[1] == "true"
end

function M.telescope(opts, callback)
  if callback == nil then
    require("persistence").save()
  else
    local path = require("util.root").git(opts)
    M.callbacks[path] = callback
  end

  require("telescope").extensions.git_worktree.git_worktree(opts)
end

-- Trigger a one time callback are linked to prev_path
M.callbacks = {}
function M.trigger_callback(path, prev_path)
  local cb = M.callbacks[prev_path]
  if cb ~= nil then
    cb(path, prev_path)
    return true
  end
  return false
end

function M.config()
  require("telescope").load_extension("git_worktree")
  local Job = require("plenary.job")
  local Hooks = require("git-worktree.hooks")
  -- Fix for using fake "bare" repos -- no-checkout + manually enabling bare flag afterwards
  Hooks.register("CREATE", function(path, _, _)
    set_current(path)
    local _, exit_code = Job:new({
      command = "git",
      args = { "config", "remote.origin.fetch", "+refs/heads/*:refs/remotes/origin/*" },
      cwd = path,
    }):sync()

    if exit_code ~= 0 then
      vim.notify(
        'Failed to configure upstream. Please run:  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"',
        vim.log.levels.ERROR
      )
    end
  end)

  Hooks.register("SWITCH", function(path, prev_path)
    local had_cb = M.trigger_callback(path, prev_path)
    if had_cb then
      set_current(path)
      return
    end
    vim.cmd("bufdo bd")
    vim.defer_fn(function()
      set_current(path)
    end, 10)
  end)
end
return M
