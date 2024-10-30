---@class util.colorscheme
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
local function start_timer(time)
  M.switch(nil, true)
  if timer ~= nil then
    timer:start(0, time, vim.schedule_wrap(M.switch)) -- every 5 secs
  end
end

local current = nil
local default = nil
function M.get()
  return require("last-color").recall() or current or default
end

-- push color changes to everything else
local on_switch = nil
function M.switch(theme, is_first)
  theme = theme or M.get()
  if theme ~= current then
    current = theme
    if vim.tbl_contains(M.configured, theme) then
      vim.cmd.colorscheme(theme)
      if on_switch then
        on_switch(theme, is_first)
      end
    end
  end
end

function M.setup(opts)
  opts = vim.tbl_extend("force", {
    reload_time = 5000,
    default_theme = "catppuccin-mocha",
    on_switch = nil,
  }, opts or {})
  default = opts.default_theme
  on_switch = opts.on_switch
  start_timer(opts.reload_time)
end

return M
