M = {}
local terminals = {}

M.get_terminals = function()
  return terminals
end
local last = nil

function M.remove_terminal_entry(cwd)
  for index, terminal in pairs(terminals) do
    if #index == #cwd and index == cwd then
      terminals[index] = nil
      terminal:close({ wipe = true })
    end
  end
end

function M.terminal(cmd, opts)
  opts = opts or {}
  if opts.cwd == nil then
    opts.cwd = require("util.root").git(opts)
  end
  local toggleterm = require("toggleterm.terminal").Terminal
  local existing = terminals[cmd or opts.cwd]
  if existing ~= nil then
    existing:toggle()
    return
  end

  local terminal = toggleterm:new({
    cmd = cmd,
    dir = opts.cwd or require("util.root").git(),
    on_open = function()
      if cmd == nil then
        last = opts.cwd
      end
    end,
  })
  terminals[cmd or opts.cwd] = terminal
  terminal:toggle()
end

function M.open_oil_terminal()
  local cwd = require("oil").get_current_dir()
  require("util.terminal").terminal(nil, { cwd = cwd })
end

function M.toggle_terminal()
  require("util.terminal").terminal(nil, { cwd = last })
end

return M
