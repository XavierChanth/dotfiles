#!/bin/bash

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

is_darwin() {
	[ "$(uname)" = 'Darwin' ]
}

while getopts "hb" opt; do
	case $opt in
	h) echo "Usage: $0 [-b]" && exit ;;
	b)
		brew=1
		;;
	*) ;;
	esac
done
# check if brew is installed
if ! command -v brew &>/dev/null; then
	echo "brew could not be found"
	echo "install brew from https://brew.sh/"
	exit
fi
if [ "$brew" == 1 ]; then
	brew bundle --file="$SCRIPT_DIRECTORY"/.xavierchanth/brew/Brewfile
fi

# zsh - setup non-committed files
touch "$SCRIPT_DIRECTORY"/.config/zsh/secrets.zsh

# stow
if ! command -v stow &>/dev/null; then
	echo "stow could not be found"
	exit
fi
stow -d "$SCRIPT_DIRECTORY" -t "$HOME" .

if is_darwin; then
	# iterm2 - must use their weird way of loading config files
	if ! [ -f "$HOME"/.iterm2_shell_integration.zsh ]; then
		curl -L https://iterm2.com/shell_integration/zsh -o "$HOME"/.iterm2_shell_integration.zsh
	fi
	defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.xavierchanth/iterm2"
	defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
fi
