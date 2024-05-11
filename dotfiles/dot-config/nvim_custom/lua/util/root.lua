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
	local root = M.get()

	local bare_root = nil
	if opts.bare then
		bare_root = vim.fs.find(".git", { type = "directory", path = root, upward = true })[1]
	end

	local git_root = bare_root or vim.fs.find(".git", { path = root, upward = true })[1]
	return git_root and vim.fn.fnamemodify(git_root, ":h") or root
end

return M
