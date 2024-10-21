local M = {}
-- A list of colors which have been configured globally across my system.
-- Other programs use the nvim last-color file to change theme when nvim's color changes
M.configured = {
  "catppuccin-mocha",
  "catppuccin-frappe",
  "catppuccin-macchiato",
  "catppuccin-latte",
  "tokyonight-night",
  "tokyonight-day",
  "tokyonight-storm",
  "tokyonight-moon",
}

-- Async reloading of colorscheme on change
local timer = vim.uv.new_timer()
local prev_color = nil

local function apply()
  local theme = require("last-color").recall() or prev_color or "catppuccin-mocha"
  vim.cmd.colorscheme(theme)
end

local function start_timer()
  if timer ~= nil then
    timer:start(0, 5000, vim.schedule_wrap(apply)) -- every 5 secs
  end
end

function M.setup()
  apply()
  start_timer()
end

-- push color changes to everything else
function M.switch(color)
  if vim.tbl_contains(M.configured, color) then
    vim.cmd.colorscheme(color)
    require("util.tmux").reload_config()
    require("util.sketchybar").reload_config()
    require("util.wezterm").set_lastcolor(color)
  end
end

return M
