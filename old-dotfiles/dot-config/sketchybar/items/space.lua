local sbar = require("sketchybar")
local opts = require("opts")

local space = sbar.add("item", {
	icon = { drawing = false },
	background = {
		color = opts.color.blue,
		padding_left = 8,
	},
	label = {
		string = "-",
		color = opts.color.base,
		padding_left = 12,
		padding_right = 12,
		font = opts.font.medium_20,
	},
	popup = {
		align = "left",
		height = 0,
		horizontal = true,
	},
})
space:subscribe("aerospace_workspace_change", function(env)
	space:set({
		label = { string = env.FOCUSED_WORKSPACE:sub(1, 1) },
		popup = { drawing = false },
	})
end)
space:subscribe("mouse.clicked", function(_)
	space:set({ popup = { drawing = "toggle" } })
end)
space:subscribe("mouse.exited.global", function(_)
	space:set({ popup = { drawing = false } })
end)

-- setup menu
local menu = {}

sbar.exec("aerospace list-workspaces --all", function(result)
	for sid in string.gmatch(result, "%d+") do
		local menu_item = sbar.add("item", {
			position = "popup." .. space.name,
			icon = { drawing = false },
			background = { color = opts.color.blue },
			label = {
				string = sid,
				color = opts.color.base,
				padding_left = 8,
				padding_right = 8,
				font = opts.font.medium_20,
			},
		})
		menu_item:subscribe("aerospace_workspace_change", function(env)
			if env.FOCUSED_WORKSPACE:sub(1, 1) == sid then
				menu_item:set({
					background = { color = opts.color.orange },
				})
			else
				menu_item:set({
					background = { color = opts.color.blue },
				})
			end
		end)
		menu_item:subscribe("mouse.clicked", function(_)
			sbar.exec("aerospace workspace " .. sid)
		end)
		menu[#menu + 1] = menu_item
	end
end)

space:subscribe("forced", function()
	sbar.exec("aerospace list-workspaces --focused", function(workspace)
		sbar.trigger("aerospace_workspace_change", {
			FOCUSED_WORKSPACE = workspace,
		})
	end)
end)
