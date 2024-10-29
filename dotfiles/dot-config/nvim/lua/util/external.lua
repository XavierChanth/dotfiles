---@class util.external
local M = {
  sketchybar = {},
  tmux = {},
  wezterm = {},
}

local Job = require("plenary.job")

function M.sketchybar.reload()
  if Util.platform.is_macos() then
    Job:new({
      command = "sketchybar",
      args = { "--reload" },
    }):sync()
  end
end

function M.tmux.reload_config()
  Job:new({
    command = "tmux",
    args = { "source-file", os.getenv("XDG_CONFIG_HOME") .. "/tmux/tmux.conf" },
  }):sync()
end

function M.tmux.reload_plugins()
  Job:new({
    command = "./tpm",
    cwd = os.getenv("XDG_CONFIG_HOME") .. "/tmux/plugins/tpm",
  }):sync()
end

function M.tmux.neww(opts)
  local args = { "neww" }
  if opts.cwd then
    args = { "neww", "-c", opts.cwd }
  end
  Job:new({
    command = "tmux",
    args = args,
  }):sync()
end

function M.tmux.start(opts)
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

function M.wezterm.set_lastcolor(colorscheme)
  local file = string.format("%s/../wezterm/lastcolor.lua", vim.fn.stdpath("config"))
  local flags = 433
  local fd = assert(vim.uv.fs_open(file, "w", flags))
  assert(vim.uv.fs_write(fd, string.format('return "%s"\n', colorscheme), -1))
  assert(vim.uv.fs_close(fd))
end

return M
