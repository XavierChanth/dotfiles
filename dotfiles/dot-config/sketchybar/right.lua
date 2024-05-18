local sbar = require("sketchybar")
local opts = require("opts")

sbar.add("item", opts.get_spacer(8, { position = "right" }))
sbar.add("item", opts.get_right_separator("surface", { position = "right" }))

local clock = sbar.add("item", {
	position = "right",
	icon = { drawing = false },
	background = { color = opts.color.surface },
	label = {
		color = opts.color.text,
		padding_left = 8,
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
		padding_right = 8,
	},
	background = { color = opts.color.purple },
	label = { drawing = false },
})

sbar.add("item", opts.get_left_separator("purple", { position = "right" }))
