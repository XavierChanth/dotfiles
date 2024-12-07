-- Taken from LazyVim's root util with some modifications
--- @class util.root
local M = {}

function M.git(opts)
  return require("snacks.git").get_root(opts and opts.cwd)
end

return M
