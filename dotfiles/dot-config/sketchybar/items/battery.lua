local sbar = require("sketchybar")
local opts = require("opts")

local battery = sbar.add("item", {
	position = "q",
	background = {
		color = opts.color.surface,
		padding_right = 20,
	},
	label = {
		string = "%",
		color = opts.color.text,
		padding_left = 8,
		padding_right = 10,
	},
	drawing = false,
})
local battery_icon = sbar.add("item", {
	position = "q",
	icon = {
		string = "-",
		padding_left = 10,
		padding_right = 8,
	},
	background = {
		color = opts.color.pink,
	},
	drawing = false,
})

battery:subscribe("battery_change", function(env)
	battery:set({ label = { string = env.percentage .. "%" } })
	if env.charging then
		battery_icon:set({ icon = { string = " " } })
	else
		local icon = " "
		local p = tonumber(env.percentage)
		if p > 79 then
			icon = " "
		elseif p > 59 then
			icon = " "
		elseif p > 39 then
			icon = " "
		elseif p > 19 then
			icon = " "
		end
		battery_icon:set({ icon = { string = icon } })
	end
end)

battery:subscribe("builtin_display_change", function(env)
	battery:set({ drawing = env.is_builtin })
	battery_icon:set({ drawing = env.is_builtin })
end)
