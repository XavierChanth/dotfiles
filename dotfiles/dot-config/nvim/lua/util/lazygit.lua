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

-- From LazyVim
function M.blame_line()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local file = vim.api.nvim_buf_get_name(0)
  local root = Util.root.detectors.pattern(0, { ".git" })[1] or "."
  local cmd = { "git", "-C", root, "log", "-u", "-L", line .. ",+1:" .. file }
  return Util.lazy.float_term(cmd, {
    interactive = false,
    filetype = "git",
    border = "rounded",
  })
end

return M
