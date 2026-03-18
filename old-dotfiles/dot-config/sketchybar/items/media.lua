local sbar = require("sketchybar")
local opts = require("opts")

local whitelist = { ["Spotify"] = true, ["Music"] = false }

local media = sbar.add("item", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "-",
		color = opts.color.text,
		padding_left = 8,
		padding_right = 10,
	},
	background = {
		color = opts.color.surface,
		padding_right = 12,
	},
	updates = true,
})

local media_icon = sbar.add("item", {
	position = "right",
	icon = {
		string = "",
		padding_left = 10,
		padding_right = 8,
	},
	background = {
		color = opts.color.yellow,
	},
	popup = {
		align = "center",
		horizontal = true,
	},
})

media:subscribe("builtin_display_change", function(env)
	if env.is_builtin == "true" then
		media:set({ position = "e", background = { padding_right = 0 } })
		media_icon:set({ position = "e", background = { padding_left = 22 } })
		sbar.exec("sketchybar --move " .. media_icon.name .. " before " .. media.name)
	else
		media:set({ position = "right", background = { padding_right = 12 } })
		media_icon:set({ position = "right", background = { padding_left = 0 } })
		sbar.exec("sketchybar --move " .. media_icon.name .. " after " .. media.name)
	end
end)

--menu
sbar.add("item", {
	position = "popup." .. media_icon.name,
	icon = { drawing = false },
	label = {
		string = "󰒮",
		color = opts.color.text,
		padding_left = 10,
		padding_right = 10,
	},
	background = { color = opts.color.surface },
}):subscribe("mouse.clicked", function()
	sbar.exec("osascript -e 'tell application \"Spotify\" to previous track'")
	media_icon:set({ popup = { drawing = false } })
end)
local playpause = sbar.add("item", {
	position = "popup." .. media_icon.name,
	icon = { drawing = false },
	label = {
		string = "󰐊",
		color = opts.color.text,
		padding_left = 10,
		padding_right = 10,
	},
	background = { color = opts.color.surface },
})
playpause:subscribe("mouse.clicked", function()
	sbar.exec("osascript -e 'tell application \"Spotify\" to playpause'")
	media_icon:set({ popup = { drawing = false } })
end)

sbar.add("item", {
	position = "popup." .. media_icon.name,
	icon = { drawing = false },
	label = {
		string = "󰒭",
		color = opts.color.text,
		padding_left = 10,
		padding_right = 10,
	},
	background = { color = opts.color.surface },
}):subscribe("mouse.clicked", function()
	sbar.exec("osascript -e 'tell application \"Spotify\" to next track'")
	media_icon:set({ popup = { drawing = false } })
end)

media_icon:subscribe("mouse.clicked", function()
	media_icon:set({ popup = { drawing = "toggle" } })
end)

media_icon:subscribe("mouse.exited.global", function()
	media_icon:set({ popup = { drawing = false } })
end)

media:subscribe("media_change", function(env)
	if whitelist[env.INFO.app] == true then
		local label = env.INFO.artist .. ": " .. env.INFO.title
		local color = opts.color.orange

		if env.INFO.state == "playing" then
			color = opts.color.green
			playpause:set({ label = { string = "󰏤" } })
		elseif env.INFO.state == "paused" then
			color = opts.color.yellow
			label = "-"
			playpause:set({ label = { string = "󰐊" } })
		end

		media:set({ label = { string = label:sub(1, 35) } })
		media_icon:set({ background = { color = color } })
	end
end)
