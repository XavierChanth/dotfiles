---@class util.tmux
local M = {
  tmux = {},
}

function M.neww(opts)
  opts = opts or {}
  local Job = require("plenary.job")
  if Util.platform.supports_terminal() then
    local args = { "neww" }
    if opts.cwd then
      args[#args + 1] = "-c"
      args[#args + 1] = opts.cwd
    end
    if opts.cmd then
      if type(opts.cmd) == "string" then
        opts.cmd = { opts.cmd }
      end

      for _, cmd in ipairs(opts.cmd) do
        args[#args + 1] = cmd --[[@as string]]
      end
    end
    Job:new({
      command = "tmux",
      args = args,
      enabled_recording = true,
      on_exit = function(job, code, _)
        if code ~= 0 then
          vim.notify(vim.inspect(job:result()), vim.log.levels.WARN, {})
        end
      end,
    }):start()
  end
end

function M.splitw(opts)
  opts = opts or {}
  opts.vertical = opts.vertical or false
  local Job = require("plenary.job")
  if Util.platform.supports_terminal() then
    local args = { "splitw" }

    if opts.vertical then
      args[#args + 1] = "-v"
    else
      args[#args + 1] = "-h"
    end

    if opts.cwd then
      args[#args + 1] = "-c"
      args[#args + 1] = opts.cwd
    end

    if opts.size then
      args[#args + 1] = "-l"
      args[#args + 1] = opts.size
    end

    if opts.cmd then
      if type(opts.cmd) == "string" then
        opts.cmd = { opts.cmd }
      end

      for _, cmd in ipairs(opts.cmd) do
        args[#args + 1] = cmd --[[@as string]]
      end
    end

    Job:new({
      command = "tmux",
      args = args,
      enabled_recording = true,
      on_exit = function(job, code, _)
        if code ~= 0 then
          vim.notify(vim.inspect(job:result()), vim.log.levels.WARN, {})
        end
      end,
    }):start()
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
