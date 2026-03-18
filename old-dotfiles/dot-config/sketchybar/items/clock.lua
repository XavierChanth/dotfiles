local sbar = require("sketchybar")
local opts = require("opts")

local clock = sbar.add("item", {
	position = "right",
	icon = { drawing = false },
	background = {
		color = opts.color.surface,
		padding_right = 8,
	},
	label = {
		color = opts.color.text,
		padding_left = 10,
		padding_right = 12,
	},
	update_freq = 1,
	script = "sketchybar --name $NAME label=$(date '+%d/%m %H:%M')",
})

local function update_clock()
	local date = os.date("%m/%d/%Y %H:%M")
	clock:set({ label = { string = date } })
end

clock:subscribe("routine", update_clock)
clock:subscribe("forced", update_clock)

sbar.add("item", {
	position = "right",
	icon = {
		string = "󰥔 ",
		color = opts.color.base,
		padding_left = 10,
		padding_right = 8,
	},
	background = { color = opts.color.purple },
	label = { drawing = false },
})
