local sbar = require("sketchybar")
local opts = require("opts")

local whitelist = { ["Spotify"] = true, ["Music"] = false }

local function init_media(position)
	return {
		position = position,
		icon = { drawing = false },
		label = {
			string = "-",
			color = opts.color.text,
			padding_left = 8,
			padding_right = 4,
		},
		background = { color = opts.color.surface },
		updates = true,
	}
end

local function init_media_icon(position)
	return {
		position = position,
		icon = {
			string = "",
			padding_right = 8,
		},
		background = {
			color = opts.color.orange,
		},
	}
end

local media
local media_icon
local media_sepl

local function builtin()
	sbar.add("item", opts.get_spacer(20, { position = "e" }))
	media_sepl = sbar.add("item", opts.get_left_separator("orange", { position = "e" }))
	media_icon = sbar.add("item", init_media_icon("e"))
	media = sbar.add("item", init_media("e"))
	sbar.add("item", opts.get_right_separator("surface", { position = "e" }))

	sbar.add("item", opts.get_spacer(16, { position = "q" }))
	sbar.add("item", opts.get_right_separator("surface", { position = "q" }))
	local battery = sbar.add("item", {
		position = "q",
		background = { color = opts.color.surface },
		label = {
			string = "%",
			color = opts.color.text,
			padding_left = 8,
			padding_right = 4,
		},
		update_freq = 1,
	})
	local battery_icon = sbar.add("item", {
		position = "q",
		icon = { string = "-", padding_right = 8 },
		background = {
			color = opts.color.pink,
			drawing = true,
		},
	})
	sbar.add("item", opts.get_left_separator("pink", { position = "q" }))

	local function update_battery(_)
		sbar.exec("pmset -g batt | grep -q 'AC Power'", function(_, exit_code)
			local is_charging = exit_code == 0
			if is_charging then
				battery_icon:set({ icon = { string = " " } })
			end
			sbar.exec('pmset -g batt | grep -Eo "\\d+%" | cut -d% -f1', function(percentage)
				battery:set({ label = { string = percentage .. "%" } })
				if not is_charging then
					local icon = " "
					local p = tonumber(percentage)
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
		end)
	end

	battery:subscribe("routine", update_battery)
	battery:subscribe("forced", update_battery)
end

local function external()
	sbar.add("item", opts.get_spacer(16, { position = "right" }))
	sbar.add("item", opts.get_right_separator("surface", { position = "right" }))
	media = sbar.add("item", init_media("right"))
	media_icon = sbar.add("item", init_media_icon("right"))
	media_sepl = sbar.add("item", opts.get_left_separator("orange", { position = "right" }))
end

-- Setup the dynamic layout based on the display query
sbar.exec(
	"system_profiler SPDisplaysDataType | grep -B 3 'Main Display:' | awk '/Display Type/ {print $3}' | grep -q 'Built-in'",
	function(_, exit_code)
		if exit_code == 0 then
			builtin()
		else
			external()
		end

		-- Subscribe to media events
		media:subscribe("media_change", function(env)
			if whitelist[env.INFO.app] == true then
				local label = env.INFO.artist .. ": " .. env.INFO.title
				local color = opts.color.orange

				if env.INFO.state == "playing" then
					color = opts.color.green
				elseif env.INFO.state == "paused" then
					color = opts.color.yellow
					label = "What was I listening to?"
				end

				media:set({ label = { string = label:sub(1, 35) } })
				media_icon:set({ background = { color = color } })
				media_sepl:set({ icon = { color = color } })
			end
		end)
		sbar.trigger("media_change", {})
	end
)
