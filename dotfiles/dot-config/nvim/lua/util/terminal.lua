M = {}
M.terminals = {}

function M.open_oil_terminal()
  local cwd = require("oil").get_current_dir()
  LazyVim.terminal(nil, { cwd = cwd })
  for _, dir in ipairs(M.terminals) do
    if dir == cwd then
      return
    end
  end
  if cwd ~= nil then
    M.terminals[#M.terminals + 1] = cwd
  end
end

return M
