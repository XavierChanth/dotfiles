M = {}

function M.is_linux_arm64()
  local uname = vim.uv.os_uname()
  return uname.sysname == "Linux" and uname.machine == "aarch64"
end

return M
