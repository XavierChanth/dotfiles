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

-- Load color file
local filename = os.getenv("HOME") .. "/.local/share/nvim/last-color"
local f = assert(io.open(filename, "r"))
local lastcolor = f:read("l")
f:close()
for index, _ in pairs(themes) do
	if index == lastcolor then
		selected = lastcolor
	end
end

-- Set wezterm to auto load the last-color file
local wezterm = require("wezterm")
wezterm.add_to_config_reload_watch_list(filename)

-- Return the theme info
return {
	current = themes[selected],
}
