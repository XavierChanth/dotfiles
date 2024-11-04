---@class util.rpc
local M = {}

function M.colorscheme()
  Util.telescope.builtin("colorscheme", {
    enable_preview = true,
    ignore_builtins = true,
    initial_mode = "normal",
    attach_mappings = function(_, map)
      map("n", "<cr>", function()
        local action_state = require("telescope.actions.state")
        local theme = action_state.get_selected_entry()
        if #theme > 0 then
          vim.cmd.colorscheme(theme[1])
        end
        vim.schedule(vim.cmd.quit)
      end)
      return true
    end,
  })
end
return M
