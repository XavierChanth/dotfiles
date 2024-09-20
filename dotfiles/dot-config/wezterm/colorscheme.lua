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

-- Load color file
local filename = os.getenv("HOME") .. "/.local/share/nvim/last-color"
local f = assert(io.open(filename, "r"))
local function read_lastcolor()
	local lastcolor = f:read("l")
	for index, _ in pairs(themes) do
		if index == lastcolor then
			selected = lastcolor
		end
	end
	return lastcolor
end

local lastcolor = read_lastcolor()

local function watch_lastcolor()
	wezterm.time.call_after(1, function()
		local current = read_lastcolor()
		if current ~= lastcolor then
			f:close()
			wezterm.reload_configuration()
			lastcolor = current
		end
		watch_lastcolor()
	end)
end

watch_lastcolor()

-- Return the theme info
return {
	current = themes[selected],
}
