---@class util.presenterm
local M = {}

-- Makes it easy to add flags later
local base_presenterm_cmd = { "presenterm" }

function M.keymaps()
  if not Util.platform.supports_terminal() then
    return
  end
  local map = vim.keymap.set
  map("n", "<leader>mpp", function()
    Util.tmux.neww({
      cmd = M.presenterm_current_file_cmd(),
    })
  end, { desc = "Present" })
  map("n", "<leader>mp\\", function()
    Util.tmux.splitw({
      cmd = M.presenterm_current_file_cmd(),
    })
  end, { desc = "Present (split right)" })
  map("n", "<leader>mp-", function()
    Util.tmux.splitw({
      vertical = true,
      cmd = M.presenterm_current_file_cmd(),
    })
  end, { desc = "Present (split below)" })
end

function M.presenterm_current_file_cmd()
  local cmd = {}
  for i, v in ipairs(base_presenterm_cmd) do
    cmd[i] = v
  end
  cmd[#cmd + 1] = vim.fn.expand("%")
  return cmd
end

return M
