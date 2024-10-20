M = {}

function M.is_linux_arm64()
  local uname = vim.uv.os_uname()
  return uname.sysname == "Linux" and uname.machine == "aarch64"
end

function M.is_macos()
  local uname = vim.uv.os_uname()
  return uname.sysname == "Darwin"
end

function M.is_windows()
  return vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
end

function M.is_gui()
  return vim.g.vscode
end

return M
