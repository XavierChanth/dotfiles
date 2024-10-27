local M = {}

---@type LazyFloat[]
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
      if #last == #cwd and last == cwd then
        last = nil
      end
    end
  end
end

function M.terminal(cmd, opts)
  opts = opts or {}
  if opts.cwd == nil then
    opts.cwd = require("util.root").git(opts)
  end
  if cmd == nil then
    last = opts.cwd
  end
  local term = require("util.lazy")
  local existing = terminals[cmd or opts.cwd]
  if existing ~= nil then
    existing:on("BufEnter", function()
      vim.fn.feedkeys("a", "normal")
    end, { once = true })
    existing:toggle()
    return
  end

  ---@type LazyFloat
  local terminal = term.float_term(cmd, {
    cwd = opts.cwd or require("util.root").git(),
    persistent = true,
  })

  terminal:show()
  terminals[cmd or opts.cwd] = terminal
end

function M.open_oil_terminal()
  local cwd = require("oil").get_current_dir()
  M.terminal(nil, { cwd = cwd })
end

function M.toggle_terminal()
  M.terminal(nil, { cwd = last })
end

return M
