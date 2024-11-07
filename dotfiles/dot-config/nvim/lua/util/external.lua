---@class util.external
local M = {
  tmux = {},
}

local Job = require("plenary.job")

function M.tmux.neww(opts)
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

function M.tmux.popup(opts)
  if Util.platform.supports_terminal() then
    local args = { "popup", "-w", "85%", "-h", "85%" }
    opts.args = opts.args or {}
    for _, v in ipairs(opts.args) do
      table.insert(args, v)
    end
    Job:new({
      command = "tmux",
      args = args,
    }):sync()
  end
end

return M
