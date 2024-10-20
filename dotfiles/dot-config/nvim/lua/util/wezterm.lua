local M = {}
local uv = vim.loop

M.set_lastcolor = function(colorscheme)
  local file = string.format("%s/../wezterm/lastcolor.lua", vim.fn.stdpath("config"))
  local flags = 433
  local fd = assert(uv.fs_open(file, "w", flags))
  assert(uv.fs_write(fd, string.format('return "%s"\n', colorscheme), -1))
  assert(uv.fs_close(fd))
end

return M
