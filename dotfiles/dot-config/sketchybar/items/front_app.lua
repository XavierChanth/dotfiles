local sbar = require("sketchybar")
local opts = require("opts")

local front_app = sbar.add("item", {
	background = { color = opts.color.surface },
	icon = { drawing = false },
	label = {
		string = "-",
		font = opts.font.medium_20,
		padding_left = 10,
		padding_right = 12,
	},
})
front_app:subscribe("front_app_switched", function(env)
	front_app:set({
		label = {
			string = env.INFO,
		},
	})
end)

front_app:subscribe("forced", function()
	sbar.exec("aerospace list-windows --focused", function(window)
		sbar.trigger("front_app_switched", {
			INFO = window:match("| ([^|]*) |"),
		})
	end)
end)
