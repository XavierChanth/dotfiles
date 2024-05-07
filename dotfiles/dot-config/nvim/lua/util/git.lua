local RootUtil = require("lazyvim.util.root")

local function repoRoot()
  local root = RootUtil.get()
  local git_root = vim.fs.find(".git", { type = "directory", path = root, upward = true })[1]
  -- local bare_root = vim.fs.find("*.git", { type = "directory", path = root, upward = true })[1]
  local ret = git_root and vim.fn.fnamemodify(git_root, ":h") or root
  return ret
end

local function worktreeRoot()
  return RootUtil.git()
end

local function worktreeAdd(opts)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  opts = opts or {}
  opts.attach_mappings = function()
    actions.select_default:replace(function(prompt_bufnr, asdf)
      local selected_entry = action_state.get_selected_entry()
      local current_line = action_state.get_current_line()

      vim.print(asdf)
      actions.close(prompt_bufnr)

      local branch = selected_entry ~= nil and selected_entry.value or current_line

      if branch == nil then
        return
      end

      local name = branch:gsub("^origin/", "", 1)
      local path = require("util.git").repoRoot() .. "/" .. name

      require("git-worktree").create_worktree(path, name)
    end)

    return true
  end
  require("telescope.builtin").git_branches(opts)
end

local function worktrees()
  require("telescope").extensions.git_worktree.git_worktrees()
end

return {
  repoRoot = repoRoot,
  worktreeRoot = worktreeRoot,
  worktreeAdd = worktreeAdd,
  worktrees = worktrees,
}
