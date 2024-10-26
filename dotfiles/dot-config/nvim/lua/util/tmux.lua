local M = {}
local Job = require("plenary.job")

function M.reload_config()
  Job:new({
    command = "tmux",
    args = { "source-file", os.getenv("XDG_CONFIG_HOME") .. "/tmux/tmux.conf" },
  }):sync()
end

function M.reload_plugins()
  Job:new({
    command = "./tpm",
    cwd = os.getenv("XDG_CONFIG_HOME") .. "/tmux/plugins/tpm",
  }):sync()
end

function M.neww(opts)
  local args = { "neww" }
  if opts.cwd then
    args = { "neww", "-c", opts.cwd }
  end
  Job:new({
    command = "tmux",
    args = args,
  }):sync()
end

function M.start(opts)
  if not opts.cmd then
    return
  end
  local args = { "neww" }
  if opts.cwd then
    table.insert(args, "-c")
    table.insert(args, opts.cwd)
  end
  Job:new({
    command = "tmux",
    args = args,
  }):sync()
end

return M
