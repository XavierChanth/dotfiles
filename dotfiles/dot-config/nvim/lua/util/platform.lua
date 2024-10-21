local M = {}

function M.is_linux_arm64()
  local uname = vim.uv.os_uname()
  return uname.sysname == "Linux" and uname.machine == "aarch64"
end
M.is_linux_arm64 = require("util.lazy").memoize(M.is_linux_arm64)

function M.is_macos()
  local uname = vim.uv.os_uname()
  return uname.sysname == "Darwin"
end
M.is_macos = require("util.lazy").memoize(M.is_macos)

function M.is_windows()
  return vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
end
M.is_windows = require("util.lazy").memoize(M.is_windows)

function M.is_gui()
  return vim.g.vscode or vim.g.neovide
end
M.is_gui = require("util.lazy").memoize(M.is_gui)

return M
