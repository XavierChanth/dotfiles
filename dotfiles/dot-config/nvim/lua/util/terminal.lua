M = {}
local terminals = {}

M.get_terminals = function()
  return terminals
end
local last = nil

function M.add_terminal_entry(opts, terminal)
  local cwd = opts.cwd
  if opts.cmd ~= nil or cwd == nil then
    return
  end
  last = cwd
  terminals[cwd] = terminal
end

function M.remove_terminal_entry(cwd)
  for index, terminal in pairs(terminals) do
    if #index == #cwd and index == cwd then
      terminals[index] = nil
      terminal:close({ wipe = true })
    end
  end
end

function M.terminal(cmd, opts)
  opts = vim.tbl_extend("force", { esc_esc = false, ctrl_hjkl = false }, opts or {})
  ---@diagnostic disable-next-line: redundant-parameter
  local terminal = LazyVim.terminal(cmd, opts)
  require("util.terminal").add_terminal_entry(opts, terminal)
end

function M.open_root_terminal()
  local cwd = require("util.root").git()
  require("util.terminal").terminal(nil, { cwd = cwd })
end

function M.open_oil_terminal()
  local cwd = require("oil").get_current_dir()
  require("util.terminal").terminal(nil, { cwd = cwd })
end

function M.open_last_terminal()
  local M = require("util.terminal")
  if last == nil then
    M.open_root_terminal()
  else
    M.terminal(nil, { cwd = last })
  end
end

return M
