local sbar = require("sketchybar")
local opts = require("opts")

sbar.bar({
	height = 40,
	color = opts.color.base,
	margin = 0,
	sticky = true,
	padding_left = 0,
	padding_right = 0,
	notch_width = 188,
	display = "main",
})

sbar.default({
	background = {
		height = 32,
		color = opts.color.transparent,
	},
	icon = {
		color = opts.color.base,
		font = opts.font.medium_20,
		padding_left = 0,
		padding_right = 0,
	},
	label = {
		color = opts.color.text,
		font = opts.font.medium_20,
		y_offset = 0,
		padding_left = 0,
		padding_right = 0,
	},
})

require("left")
require("right")
require("middle")
-- #!/usr/bin/env zsh
-- # Config starting point from https://github.com/neutonfoo/dotfiles/tree/main/.config/sketchybar
-- # Thanks @neutonfoo!
-- SKETCHYBAR_CONFIG="$HOME/.config/sketchybar"
-- MAIN_DISPLAY=$(system_profiler SPDisplaysDataType | grep -B 3 'Main Display:' | awk '/Display Type/ {print $3}')
-- is_builtin() {
--   [[ $MAIN_DISPLAY = "Built-in" ]]
-- }
--
-- PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
-- SPOTIFY_EVENT="com.spotify.client.PlaybackStateChanged"
--
-- ### LEFT LAYOUT ###
--
-- ### LEFT STYLE ###

-- ### REST OF LAYOUT ###
--
-- # Clock
-- # Dynamic elements
--
--
-- ### RIGHT STYLE ###
--
-- # Battery
-- if is_builtin; then
--   sketchybar --set battery \
--     background.color=$color_surface0 \
--     label.color=$color_text \
--     label.padding_left=8 \
--     update_freq=20 \
--     script="$PLUGIN_DIR/battery.sh" \
--     --set battery.icon \
--     icon.color=$color_base \
--     icon.padding_right=8 \
--     background.color=$color_pink \
--     background.drawing=on
-- fi
--
-- # Spotify
-- sketchybar --set spotify \
--   label.padding_left=4 \
--   label.padding_right=4 \
--   label="  " \
--   label.color=$color_text \
--   background.color=$color_surface0 \
--   script="$PLUGIN_DIR/spotify.sh" \
--   --subscribe spotify spotify_change mouse.clicked \
--   --set spotify.icon \
--   icon= \
--   background.color=$color_peach \
--   script="$PLUGIN_DIR/spotify.sh" \
--   --subscribe spotify.icon mouse.clicked \
--   --set spotifysepl \
--   icon=\
--   icon.color=$color_peach \
--   icon.font="$FONT_FACE:Bold:24.0" \
--   label.drawing=no \
--   background.drawing=no \
--   icon.padding_right=-1 \
--   --set spotifysepr \
--   icon= \
--   icon.color=$color_surface0 \
--   icon.font="$FONT_FACE:Bold:24.0" \
--   icon.padding_left=0 \
--   icon.padding_right=0 \
--   label.drawing=no \
--   background.drawing=no
--
-- ### Left Separators ###
-- sketchybar --set seplblue \
--   icon=\
--   icon.color=$color_blue \
--   icon.font="$FONT_FACE:Bold:24.0" \
--   label.drawing=no \
--   background.drawing=no \
--   icon.padding_right=-1 \
--   --set seplmauve \
--   icon=\
--   icon.color=$color_mauve \
--   icon.font="$FONT_FACE:Bold:24.0" \
--   label.drawing=no \
--   background.drawing=no \
--   icon.padding_right=-1 \
--   --set seplpink \
--   icon=\
--   icon.color=$color_pink \
--   icon.font="$FONT_FACE:Bold:24.0" \
--   label.drawing=no \
--   background.drawing=no \
--   icon.padding_right=-1
--
-- ### Right Separators ###
-- sketchybar --set seprblue \
--   icon=\
--   icon.color=$color_blue \
--   icon.font="$FONT_FACE:Bold:24.0" \
--   icon.padding_left=0 \
--   icon.padding_right=0 \
--   label.drawing=no \
--   background.drawing=no \
--   --set seprdef1 \
--   icon=\
--   icon.color=$color_surface0 \
--   icon.font="$FONT_FACE:Bold:24.0" \
--   icon.padding_left=0 \
--   icon.padding_right=0 \
--   label.drawing=no \
--   background.drawing=no\
--   --set seprdef2 \
--   icon=\
--   icon.color=$color_surface0 \
--   icon.font="$FONT_FACE:Bold:24.0" \
--   icon.padding_left=0 \
--   icon.padding_right=0 \
--   label.drawing=no \
--   background.drawing=no \
--   --set seprdef3 \
--   icon=\
--   icon.color=$color_surface0 \
--   icon.font="$FONT_FACE:Bold:24.0" \
--   icon.padding_left=0 \
--   icon.padding_right=0 \
--   label.drawing=no \
--   background.drawing=no
--
-- ### Spacers ###
-- sketchybar --set spacerleft \
--   icon.drawing=no \
--   label.drawing=no \
--   background.color=$color_transparent \
--   background.padding_left=8 \
--   --set spacerright \
--   icon.drawing=no \
--   label.drawing=no \
--   background.color=$color_transparent \
--   background.padding_left=8 \
--   --set spacer1 \
--   icon.drawing=no \
--   label.drawing=no \
--   background.color=$color_transparent \
--   background.padding_left=16 \
--   --set spacer2 \
--   icon.drawing=no \
--   label.drawing=no \
--   background.color=$color_transparent \
--   background.padding_left=20 \
--   --set spacer3 \
--   icon.drawing=no \
--   label.drawing=no \
--   background.color=$color_transparent \
--   background.padding_left=16
--
--
-- ### Finalizing Setup ###
-- sketchybar --update
-- sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
-- sketchybar --trigger front_app_switched INFO=$(aerospace list-windows --focused | cut -d'|' -f2 | tr -d " ")
-- # sketchybar --trigger spotify_change INFO="com.spotify.client.PlaybackStateChanged"
