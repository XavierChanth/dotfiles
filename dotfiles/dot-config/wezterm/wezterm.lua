local wezterm = require("wezterm")

local front_end = "OpenGL"
local path = os.getenv("PATH")

local default_prog = { "tmux", "new", "-A", "-s", "main" }

if wezterm.target_triple == "aarch64-apple-darwin" then
	front_end = "WebGpu" -- colors are wrong with OpenGL on macos
	path = path .. ":/opt/homebrew/bin"
end

local colorscheme = require("colorscheme")
local config = {
	check_for_updates = false,
	color_scheme = colorscheme.current,
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	default_prog = default_prog,
	disable_default_key_bindings = true,
	enable_tab_bar = false,
	font = wezterm.font("JetBrainsMono NF"),
	font_size = 24.0,
	front_end = front_end,
	hyperlink_rules = wezterm.default_hyperlink_rules(),
	max_fps = 144,
	macos_window_background_blur = 20,
	quit_when_all_windows_are_closed = false,
	window_decorations = "RESIZE", -- no title, but window is properly resizable
	window_padding = {
		left = "0.5cell",
		right = "0.5cell",
		top = "2",
		bottom = "2",
	},
	term = "wezterm",
	set_environment_variables = {
		PATH = path,
	},
	keys = {
		-- typical terminal emulator mappings
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
			key = "q",
			mods = "CMD",
			action = wezterm.action.QuitApplication,
		},
		{
			key = "t",
			mods = "CMD",
			action = wezterm.action.SpawnWindow,
		},
		{
			key = "c",
			mods = "CMD",
			action = wezterm.action.CopyTo("Clipboard"),
		},
		{
			key = "v",
			mods = "CMD",
			action = wezterm.action.PasteFrom("Clipboard"),
		},
		{
			key = "=",
			mods = "CMD",
			action = wezterm.action.IncreaseFontSize,
		},
		{
			key = "-",
			mods = "CMD",
			action = wezterm.action.DecreaseFontSize,
		},
		{
			key = "0",
			mods = "CMD",
			action = wezterm.action.ResetFontSize,
		},
		-- for vim / less
		{
			key = "j",
			mods = "CMD",
			action = wezterm.action.Multiple({
				wezterm.action.SendKey({ key = "5" }),
				wezterm.action.SendKey({ key = "j" }),
			}),
		},
		{
			key = "k",
			mods = "CMD",
			action = wezterm.action.Multiple({
				wezterm.action.SendKey({ key = "5" }),
				wezterm.action.SendKey({ key = "k" }),
			}),
		},
	},
}

-- A list of keys to map hyper + key to tmux prefix + key
local hyper_to_tmux_prefix_key = {
	-- 1:1 mappings
	["a"] = "a",
	["s"] = "s",
	["d"] = "d",
	["r"] = "r",
	["c"] = "c",
	["l"] = "l",
	["x"] = "x",
	["w"] = "w",
	["z"] = "z",
	-- weird mappings
	["q"] = "d",
	["Tab"] = "L",
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
			action = wezterm.action.Multiple({
				wezterm.action.SendKey({
					key = " ",
					mods = "CTRL",
				}),
				wezterm.action.SendKey({
					key = istr,
				}),
			}),
		}
	end
end

return config
