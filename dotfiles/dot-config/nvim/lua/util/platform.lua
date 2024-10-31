---@class util.platform
local M = {}

function M.is_linux_arm64()
  local uname = vim.uv.os_uname()
  return uname.sysname == "Linux" and uname.machine == "aarch64"
end
M.is_linux_arm64 = Util.lazy.memoize(M.is_linux_arm64)

function M.is_macos()
  local uname = vim.uv.os_uname()
  return uname.sysname == "Darwin"
end
M.is_macos = Util.lazy.memoize(M.is_macos)

function M.is_windows()
  return vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
end
M.is_windows = Util.lazy.memoize(M.is_windows)

function M.is_gui()
  -- Don't put neovide here, it's basically a terminal and supports most things
  return vim.g.vscode
end
M.is_gui = Util.lazy.memoize(M.is_gui)

function M.supports_terminal()
  return not vim.g.vscode
end
M.supports_terminal = Util.lazy.memoize(M.supports_terminal)

function M.supports_lsp()
  return not vim.g.vscode
end
M.supports_lsp = Util.lazy.memoize(M.supports_lsp)

return M
