M = {}
M.terminals = {}

function M.terminal(cmd, opts)
  opts = vim.tbl_deep_extend("force", { esc_esc = false, ctrl_hjkl = false }, opts or {})
  ---@diagnostic disable-next-line
  LazyVim.terminal(cmd, opts)
end

function M.open_oil_terminal()
  local cwd = require("oil").get_current_dir()
  M.terminal(nil, { cwd = cwd })
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
