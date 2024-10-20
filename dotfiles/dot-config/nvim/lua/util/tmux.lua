local M = {}
local Job = require("plenary.job")

M.reload_config = function()
  Job:new({
    command = "tmux",
    args = { "source-file", os.getenv("XDG_CONFIG_HOME") .. "/tmux/tmux.conf" },
  }):sync()
end

M.reload_plugins = function()
  Job:new({
    command = "./tpm",
    cwd = os.getenv("XDG_CONFIG_HOME") .. "/tmux/plugins/tpm",
  }):sync()
end

M.neww = function(opts)
  local args = { "neww" }
  if opts.cwd then
    args = { "neww", "-c", opts.cwd }
  end
  Job:new({
    command = "tmux",
    args = args,
  }):sync()
end

return M
