os.execute(
	"[ ! -d $HOME/.local/share/sketchybar_themes/catppuccin ] && "
		.. "git clone https://github.com/catppuccin/lua.git $HOME/.local/share/sketchybar_themes/catppuccin"
)
os.execute(
	"[ ! -d $HOME/.local/share/sketchybar_themes/tokyonight ] && "
		.. "git clone https://github.com/folke/tokyonight.nvim $HOME/.local/share/sketchybar_themes/tokyonight && "
		.. "echo 'return colors' >> $HOME/.local/share/sketchybar_themes/tokyonight/extras/lua/tokyonight_day.lua &&"
		.. "echo 'return colors' >> $HOME/.local/share/sketchybar_themes/tokyonight/extras/lua/tokyonight_night.lua &&"
		.. "echo 'return colors' >> $HOME/.local/share/sketchybar_themes/tokyonight/extras/lua/tokyonight_moon.lua &&"
		.. "echo 'return colors' >> $HOME/.local/share/sketchybar_themes/tokyonight/extras/lua/tokyonight_storm.lua"
)

local cat = require("colors.catppuccin")
local tok = require("colors.tokyonight")

local themes = {
	["catppuccin-mocha"] = cat.transform(cat.mocha),
	["catppuccin-latte"] = cat.transform(cat.latte),
	["catppuccin-frappe"] = cat.transform(cat.frappe),
	["catppuccin-macchiato"] = cat.transform(cat.macchiato),
	["tokyonight-day"] = tok.transform(tok.day),
	["tokyonight-moon"] = tok.transform(tok.moon),
	["tokyonight-night"] = tok.transform(tok.night),
	["tokyonight-storm"] = tok.transform(tok.storm),
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

-- Return the theme info
return {
	current = themes[selected](),
}
