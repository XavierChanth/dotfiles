local sbar = require("sketchybar")

local display_watcher
local battery_watcher
local battery = {
	percentage = 100,
	charging = false,
}

local M = {}

function M.setup_events()
	sbar.add("event", "aerospace_workspace_change")
	sbar.add("event", "builtin_display_change")
	sbar.add("event", "screen_unlock", "com.apple.screenIsUnlocked")
	display_watcher = sbar.add("item", {
		drawing = false,
		updates = true,
	})
	sbar.add("event", "battery_change")
	battery_watcher = sbar.add("item", {
		drawing = false,
		update_freq = 60, -- check battery once per minute
	})
end

local function is_builtin_display(cb)
	sbar.exec(
		"system_profiler SPDisplaysDataType | grep -B 3 'Main Display:' | awk '/Display Type/ {print $3}' | grep -q 'Built-in'",
		function(_, exit_code)
			cb(exit_code == 0)
		end
	)
end

local function update_display(_)
	is_builtin_display(function(is_builtin)
		sbar.trigger("builtin_display_change", { is_builtin = tostring(is_builtin) })
		if is_builtin then
			sbar.bar({ position = "top" })
		else
			sbar.bar({ position = "bottom" })
		end
	end)
end

local function update_battery(_)
	sbar.exec('pmset -g batt | grep -Eo "\\d+%" | cut -d% -f1', function(percentage)
		if battery.percentage ~= percentage then
			battery.percentage = percentage
			sbar.trigger("battery_change", { percentage = percentage, charging = battery.charging })
		end
	end)
end

function M.trigger_events()
	display_watcher:subscribe("system_woke", update_display)
	display_watcher:subscribe("screen_unlock", update_display)
	display_watcher:subscribe("display_change", update_display)
	display_watcher:subscribe("forced", update_display)

	battery_watcher:subscribe("routine", update_battery)
	battery_watcher:subscribe("forced", update_battery)
	battery_watcher:subscribe("power_source_change", function(env)
		local charging = (env.INFO == "AC")
		if battery.charging ~= charging then
			battery.charging = charging
			sbar.trigger("battery_change", { percentage = battery.percentage, charging = charging })
		end
	end)
end

return M
