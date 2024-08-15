M = {}
M.terminals = {}

function M.open_oil_terminal()
  local cwd = require("oil").get_current_dir()
  LazyVim.terminal(nil, { cwd = cwd })
  if cwd ~= nil then
    M.terminals[#M.terminals + 1] = cwd
  end
end

return M
