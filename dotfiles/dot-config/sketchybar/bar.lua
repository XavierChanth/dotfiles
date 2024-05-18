local sbar = require("sketchybar")
local opts = require("opts")

sbar.bar({
	height = 40,
	color = opts.color.base,
	margin = 0,
	sticky = true,
	padding_left = 0,
	padding_right = 0,
	notch_width = 188,
	display = "main",
})

sbar.default({
	background = {
		height = 32,
		color = opts.color.transparent,
	},
	icon = {
		color = opts.color.base,
		font = opts.font.medium_20,
		padding_left = 0,
		padding_right = 0,
	},
	label = {
		color = opts.color.text,
		font = opts.font.medium_20,
		y_offset = 0,
		padding_left = 0,
		padding_right = 0,
	},
})

sbar.hotload(true)
