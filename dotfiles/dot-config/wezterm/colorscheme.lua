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

-- Try to set the theme from lastcolor
local lastcolor = require("lastcolor")
for index, _ in pairs(themes) do
	if index == lastcolor then
		selected = lastcolor
	end
end

-- Return the theme info
return {
	current = themes[selected],
}
