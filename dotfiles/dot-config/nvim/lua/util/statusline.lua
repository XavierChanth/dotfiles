---@class util.statusline
local M = {}

function M.python_kernel_component()
  if Util.lazy.is_loaded("molten-nvim") then
    return require("molten.status").kernels()
  end
  return ""
end

-- From LazyVim's UI settings
function M.command_component()
  ---@diagnostic disable-next-line: undefined-field
  if Util.lazy.has("noice.nvim") and require("noice").api.status.command.has() then
    ---@diagnostic disable-next-line: undefined-field
    return require("noice").api.status.command.get()
  end
  return ""
end

-- From LazyVim's UI settings
function M.mode_component()
  ---@diagnostic disable-next-line: undefined-field
  if Util.lazy.has("noice.nvim") and require("noice").api.status.mode.has() then
    ---@diagnostic disable-next-line: undefined-field
    return require("noice").api.status.mode.get()
  end
  return ""
end

function M.branch_component()
  if Util.lazy.has("neogit") then
    return require("neogit").lib.git.branch.current()
  end
  return ""
end

return M
