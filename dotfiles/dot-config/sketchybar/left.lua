local sbar = require("sketchybar")
local opts = require("opts")

sbar.add("event", "aerospace_workspace_change")
sbar.exec("aerospace list-workspaces --all", function(result)
	-- workspaces
	sbar.add("item", opts.get_spacer(8))
	sbar.add("item", opts.get_left_separator("blue"))
	for sid in string.gmatch(result, "%d+") do
		local space = sbar.add("item", {
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
		space:subscribe("aerospace_workspace_change", function(env)
			if env.FOCUSED_WORKSPACE:sub(1, 1) == sid then
				space:set({
					background = { color = opts.color.peach },
				})
			else
				space:set({
					background = { color = opts.color.blue },
				})
			end
		end)
		space:subscribe("mouse.clicked", function(_)
			sbar.exec("aerospace workspace " .. sid)
		end)
	end

	sbar.add("item", opts.get_right_separator("blue"))

	-- front_app
	local front_app = sbar.add("item", {
		background = { color = opts.color.transparent },
		icon = { drawing = false },
		label = {
			string = "",
			font = opts.font.medium_20,
			padding_left = 6,
		},
	})
	front_app:subscribe("front_app_switched", function(env)
		front_app:set({
			label = {
				string = env.INFO,
			},
		})
	end)
	sbar.exec("aerospace list-windows --focused", function(window)
		sbar.trigger("front_app_switched", {
			INFO = window:match("| (.*) |"),
		})
	end)
	sbar.exec("aerospace list-workspaces --focused", function(workspace)
		sbar.trigger("aerospace_workspace_change", {
			FOCUSED_WORKSPACE = workspace,
		})
	end)
end)
