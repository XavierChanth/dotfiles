---@class util.tmux
local M = {
  tmux = {},
}

function M.neww(opts)
  local Job = require("plenary.job")
  if Util.platform.supports_terminal() then
    local args = { "neww" }
    if opts.cwd then
      args = { "neww", "-c", opts.cwd }
    end
    Job:new({
      command = "tmux",
      args = args,
    }):sync()
  end
end

function M.popup(opts)
  local Job = require("plenary.job")
  if Util.platform.supports_terminal() then
    local args = { "popup", "-w", "85%", "-h", "85%" }
    opts.args = opts.args or {}
    for _, v in ipairs(opts.args) do
      table.insert(args, v)
    end
    Job:new({
      command = "tmux",
      args = args,
    }):start()
  end
end

return M
