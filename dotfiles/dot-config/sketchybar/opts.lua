local colorscheme = require("colorscheme")
local style = "diagonal" -- "bubbles" | "diagonal"

M = {}

M.merge = function(left, right)
	for k, v in pairs(right) do
		left[k] = v
	end
	return left
end

M.color = colorscheme.current
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
	separator = {
		family = M.font_face,
		style = "Regular",
		size = 36.1,
	},
	separator2 = {
		family = M.font_face,
		style = "Regular",
		size = 24.5,
	},
}

M.get_left_separator = function(color, override)
	override = override or {}
	if style == "bubbles" then
		return M.merge({
			icon = {
				string = "",
				color = M.color[color],
				font = M.font.separator,
				padding_right = -16,
			},
			label = { drawing = false },
			background = { drawing = false },
		}, override)
	else
		return M.merge({
			icon = {
				string = "█",
				color = M.color[color],
				font = M.font.separator2,
				padding_right = -2,
			},
			label = { drawing = false },
			background = { drawing = false },
		}, override)
	end
end

M.get_right_separator = function(color, override)
	override = override or {}
	if style == "bubbles" then
		return M.merge({
			icon = {
				string = "",
				color = M.color[color],
				font = M.font.separator,
				padding_left = -16,
			},
			label = { drawing = false },
			background = { drawing = false },
		}, override)
	else
		return M.merge({
			icon = {
				string = "█",
				color = M.color[color],
				font = M.font.separator2,
			},
			label = { drawing = false },
			background = { drawing = false },
		}, override)
	end
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
