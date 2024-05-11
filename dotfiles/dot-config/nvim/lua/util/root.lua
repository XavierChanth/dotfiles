M = {}
M.cache = {}

function M.get()
  local buf = vim.api.nvim_get_current_buf()
  local ret = M.cache[buf]

  if not ret then
    ret = vim.uv.cwd()
    M.cache[buf] = ret
  end

  return ret
end

function M.git(opts)
  opts = opts or {}
  local root = M.get()
  local git_root = nil

  if opts.bare then
    git_root = vim.fs.find(".git", { type = "directory", path = root, upward = true })[1]
  end

  git_root = git_root or vim.fs.find(".git", { path = root, upward = true })[1]
  return git_root and vim.fn.fnamemodify(git_root, ":h") or root
end

return M
