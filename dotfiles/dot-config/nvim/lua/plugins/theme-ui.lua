---@type logo
local logo = require("util.logos")["nvim_sharp"]

return {
  {
    "nvimdev/dashboard-nvim",
    opts = {
      config = {
        header = vim.split("\n\n" .. logo .. "\n\n", "\n"),
        center = require("util.dashboard").actions,
      },
    },
  },
  require("util.statusline").get({
    statusline = "lualine",
    theme = "minimal",
  }),
}
