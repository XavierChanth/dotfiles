local wezterm = require("wezterm")

local tmux = "tmux"
local front_end = "OpenGL"

if wezterm.target_triple == "aarch64-apple-darwin" then
	tmux = "/opt/homebrew/bin/tmux"
	front_end = "WebGpu" -- colors are wrong with OpenGL on macos
end

local config = {
	adjust_window_size_when_changing_font_size = false,
	color_scheme = "Catppuccin Mocha",
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	disable_default_key_bindings = true,
	enable_tab_bar = false,
	font = wezterm.font("JetBrainsMono NF"),
	font_size = 24.0,
	front_end = front_end,
	hyperlink_rules = wezterm.default_hyperlink_rules(),
	keys = {
		{
			key = "r",
			mods = "CMD",
			action = wezterm.action.ReloadConfiguration,
		},
		{
			key = "w",
			mods = "CMD",
			action = wezterm.action.CloseCurrentTab({ confirm = false }),
		},
		{
			key = "t",
			mods = "CMD",
			action = wezterm.action.SpawnWindow,
		},
	},
	window_decorations = "RESIZE", -- no title, but window is properly resizable
	set_environment_variables = {
		PATH = os.getenv("PATH"),
	},
	default_prog = {
		tmux,
		"new",
		"-A",
		"-s",
		"main",
	},
}

-- A list of keys to map hyper + key to tmux prefix + key
local hyper_to_tmux_prefix_key = {
	["a"] = "a",
	["s"] = "s",
	["d"] = "D",
	["c"] = "c",
	["x"] = "x",
}

for key_in, key_out in pairs(hyper_to_tmux_prefix_key) do
	config.keys[#config.keys + 1] = {
		key = key_in,
		mods = "CTRL|OPT|SHIFT|CMD",
		action = wezterm.action.Multiple({
			wezterm.action.SendKey({
				key = " ",
				mods = "CTRL",
			}),
			wezterm.action.SendKey({
				key = key_out,
			}),
		}),
	}
end

-- map CMD + 1-9 to tmux panes
for i = 1, 9 do
	if i ~= nil then
		local istr = string.format("%d", i)
		config.keys[#config.keys + 1] = {
			key = istr,
			mods = "CMD",
			action = wezterm.action_callback(function(_, _)
				wezterm.run_child_process({
					tmux,
					"select-window",
					"-t",
					":" .. istr,
				})
			end),
		}
	end
end

return config
