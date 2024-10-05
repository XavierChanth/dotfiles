local colors = require("colors")
M = {}

M.color = colors.current
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

return M
