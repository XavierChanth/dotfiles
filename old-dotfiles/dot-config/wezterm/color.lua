local wezterm = require("wezterm")
-- Map of nvim theme names to wezterm theme names
local themes = {
	["catppuccin-mocha"] = "Catppuccin Mocha",
	["catppuccin-frappe"] = "Catppuccin Frappe",
	["catppuccin-macchiato"] = "Catppuccin Macchiato",
	["catppuccin-latte"] = "Catppuccin Latte",
	["tokyonight-night"] = "Tokyo Night",
	["tokyonight-day"] = "Tokyo Night Day",
	["tokyonight-storm"] = "Tokyo Night Storm",
	["tokyonight-moon"] = "Tokyo Night Moon",
}

-- Set the default theme
local selected = "catppuccin-mocha"

package.path = os.getenv("HOME") .. "/.local/state/colorscheme/colorscheme.lua;" .. package.path

-- Initial load of lastcolor
local initial = require("colorscheme") or selected
for theme, _ in pairs(themes) do
	if theme == initial then
		selected = initial
	end
end

-- Force reload lastcolor every 5 seconds and see if we need to reset the theme
wezterm.time.call_after(5, function()
	package.loaded["lastcolor"] = nil
	if initial ~= require("lastcolor") then
		wezterm.reload_configuration()
	end
end)

-- Return the theme info
return {
	current = themes[selected],
}
