local M = {}
M.day = dofile(os.getenv("HOME") .. "/.local/share/sketchybar_themes/tokyonight/extras/lua/tokyonight_day.lua")
M.moon = dofile(os.getenv("HOME") .. "/.local/share/sketchybar_themes/tokyonight/extras/lua/tokyonight_moon.lua")
M.night = dofile(os.getenv("HOME") .. "/.local/share/sketchybar_themes/tokyonight/extras/lua/tokyonight_night.lua")
M.storm = dofile(os.getenv("HOME") .. "/.local/share/sketchybar_themes/tokyonight/extras/lua/tokyonight_storm.lua")

function M.transform(palette)
	local compute = function(m)
		return 0xff000000 + tonumber(m:sub(2), 16)
	end
	return function()
		return {
			transparent = 0x00000000,
			base = compute(palette.bg),
			surface = compute(palette.bg_highlight),
			text = compute(palette.fg),
			blue = compute(palette.blue),
			pink = compute(palette.magenta),
			orange = compute(palette.orange),
			purple = compute(palette.purple),
			green = compute(palette.green),
			yellow = compute(palette.yellow),
		}
	end
end
return M
