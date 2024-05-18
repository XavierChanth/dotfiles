os.execute(
	"[ ! -d $HOME/.local/share/sketchybar_themes/catppuccin ] && "
		.. "git clone https://github.com/catppuccin/lua.git $HOME/.local/share/sketchybar_themes/catppuccin"
)

local catppuccin_mocha = dofile(os.getenv("HOME") .. "/.local/share/sketchybar_themes/catppuccin/catppuccin/mocha.lua")
local catppuccin_frappe =
	dofile(os.getenv("HOME") .. "/.local/share/sketchybar_themes/catppuccin/catppuccin/frappe.lua")
local catppuccin_macchiato =
	dofile(os.getenv("HOME") .. "/.local/share/sketchybar_themes/catppuccin/catppuccin/macchiato.lua")
local catppuccin_latte = dofile(os.getenv("HOME") .. "/.local/share/sketchybar_themes/catppuccin/catppuccin/latte.lua")

local catppuccin_transform = function(palette)
	local compute = function(m)
		return 0xff000000 + (0x10000 * m.rgb[1]) + (0x100 * m.rgb[2]) + m.rgb[3]
	end
	return {
		transparent = 0x00000000,
		base = compute(palette.base),
		surface = compute(palette.surface0),
		text = compute(palette.text),
		blue = compute(palette.blue),
		pink = compute(palette.pink),
		orange = compute(palette.peach),
		purple = compute(palette.mauve),
		green = compute(palette.green),
		yellow = compute(palette.yellow),
	}
end

local themes = {
	catppuccin = function()
		return catppuccin_transform(catppuccin_mocha)
	end,
	["catppuccin-mocha"] = function()
		return catppuccin_transform(catppuccin_mocha)
	end,
	["catppuccin-frappe"] = function()
		return catppuccin_transform(catppuccin_frappe)
	end,
	["catppuccin-macchiato"] = function()
		return catppuccin_transform(catppuccin_macchiato)
	end,
	["catppuccin-latte"] = function()
		return catppuccin_transform(catppuccin_latte)
	end,
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
	old = old,
	current = themes[selected](),
}
