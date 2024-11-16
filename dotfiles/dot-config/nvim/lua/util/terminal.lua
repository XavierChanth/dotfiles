---@class util.terminal
local M = {}

setmetatable(M, {
  __call = function(_, ...)
    return M.terminal(...)
  end,
})

local terminals = {}

M.get_terminals = function()
  return terminals
end
local last = nil

function M.remove(cwd)
  for index, term in pairs(terminals) do
    if #index == #cwd and index == cwd then
      term.terminal:close({ wipe = true })
      terminals[index] = nil
      if #last == #cwd and last == cwd then
        last = nil
      end
    end
  end
end

function M.try_existing(existing)
  local terminal = existing.terminal
  if terminal ~= nil and terminal:buf_valid() then
    terminal:on("BufEnter", function()
      vim.fn.feedkeys("a", "normal")
    end, { once = true })
    terminal:toggle()
    return true
  end
  return false
end

function M.new(cmd, opts)
  local terminal = Util.lazy.float_term(cmd, {
    cwd = opts.cwd or Util.root.git(),
    persistent = true,
  })

  terminal:show()
  terminals[cmd or opts.cwd] = {
    cmd = cmd,
    terminal = terminal,
    opts = opts,
  }
end

function M.existing_terminal(index)
  local existing = terminals[index]
  if existing.cmd == nil then
    last = existing.opts.cwd
  end

  if existing and M.try_existing(existing) then
    return
  end

  M.new(existing.cmd, existing.opts)
end

function M.terminal(cmd, opts)
  opts = opts or {}
  if opts.cwd == nil then
    opts.cwd = Util.root.git(opts)
  end
  if cmd == nil then
    last = opts.cwd
  end
  local existing = terminals[cmd or opts.cwd]
  if existing and M.try_existing(existing) then
    return
  end

  M.new(cmd, opts)
end

function M.from_oil()
  local cwd = require("oil").get_current_dir()
  M.terminal(nil, { cwd = cwd })
end

function M.toggle()
  M.terminal(nil, { cwd = last })
end

function M.telescope(opts)
  local names = {}
  for name, term in pairs(M.get_terminals()) do
    if term ~= nil then
      names[#names + 1] = name
    end
  end

  require("telescope.pickers")
    .new(opts, {
      prompt_title = "Terminals",
      finder = require("telescope.finders").new_table(names),
      sorter = require("telescope.config").values.generic_sorter(opts),
      initial_mode = "normal",
      attach_mappings = function(prompt_bufnr, map)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local item = action_state.get_selected_entry()[1]
          M.existing_terminal(item)
          vim.schedule(vim.cmd.startinsert)
        end)
        local function delete_from_telescope()
          ---@diagnostic disable-next-line: redundant-parameter
          local cwd = action_state.get_selected_entry(prompt_bufnr)[1]
          M.remove(cwd)
        end
        map("i", "<C-d>", delete_from_telescope)
        map("n", "<C-d>", delete_from_telescope)
        return true
      end,
    })
    :find()
end

return M
