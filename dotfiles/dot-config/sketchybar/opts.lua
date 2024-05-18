M = {}

M.merge = function(left, right)
	for k, v in pairs(right) do
		left[k] = v
	end
	return left
end

M.color = {
	transparent = 0x00000000,
	base = 0xff1e1e2e,
	surface0 = 0xff313244,
	text = 0xffcdd6f4,
	blue = 0xff89b4fa,
	pink = 0xfff5c2e7,
	peach = 0xfffab387,
	teal = 0xff94e2d5,
	mauve = 0xffcba6f7,
	green = 0xffa6e3a1,
	yellow = 0xfff9e2af,
}

M.font_face = "JetBrainsMono Nerd Font"

M.font = {
	bold_24 = {
		family = M.font_face,
		style = "Bold",
		size = 24.0,
	},
	medium_20 = {
		family = M.font_face,
		style = "Medium",
		size = 20.0,
	},
}

M.get_left_separator = function(color, override)
	override = override or {}
	return M.merge({
		icon = {
			string = "",
			color = M.color[color],
			font = M.font.bold_24,
			padding_right = -1,
		},
		label = { drawing = false },
		background = { drawing = false },
	}, override)
end

M.get_right_separator = function(color, override)
	override = override or {}
	return M.merge({
		icon = {
			string = "",
			color = M.color[color],
			font = M.font.bold_24,
			padding_left = 0,
			padding_right = 0,
		},
		label = { drawing = false },
		background = { drawing = false },
	}, override)
end

M.get_spacer = function(size, override)
	override = override or {}
	return M.merge({
		icon = { drawing = false },
		label = { drawing = false },
		background = {
			color = M.color.transparent,
			padding_left = size,
		},
	}, override)
end

return M
