---@type logo
local logo = require("util.logos")["nvim_sharp"]
return {
  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    opts = function()
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end
      return {
        theme = "doom",
        config = {
          header = vim.split("\n\n" .. logo .. "\n\n", "\n"),
          center = require("util.dashboard").actions,
        }
      }
    end
  },
  require("util.statusline").get({
    statusline = "lualine",
    theme = "minimal",
  }),
}
