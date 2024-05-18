local M = {}

-- A list of colors which have been configured globally across my system.
-- Other programs use the nvim last-color file to change theme when nvim's color changes
M.configured = {
  "catppuccin-mocha",
  "catppuccin-frappe",
  "catppuccin-macchiato",
  "catppuccin-latte",
}

M.switch = function(color)
  if vim.tbl_contains(M.configured, color) then
    vim.cmd.colorscheme(color)
    require("util.tmux").reload_config()
    require("util.sketchybar").reload_config()
  end
end

return M
