#!/bin/bash

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

is_darwin() {
	[ "$(uname)" = 'Darwin' ]
}

while getopts "hb" opt; do
	case $opt in
	h) echo "Usage: $0 [-bh]" && exit ;;
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

_home_zshenv=$([ -f "$HOME"/.zshenv ])
_home_zshenv_link=$([ -L "$HOME"/.zshenv ])
_dot_zshenv=$([ -f "$SCRIPT_DIRECTORY"/.zshenv ])
if ! $_home_zshenv_link; then
	if $_home_zshenv; then
		cp "$HOME"/.zshenv "$HOME"/.zshenv.bak
		echo "Made a backup of ~/.zshenv at $HOME/.zshenv.bak"
		if ! _dot_zshenv; then
			mv "$HOME"/.zshenv "$SCRIPT_DIRECTORY"/.zshenv
			echo "Moving existing ~/.zshenv from the home directory into the dotfiles repo"
		else
			echo "Found a .zshenv file in both the home directory and dotfiles repo"
			echo "Using the .zshenv file in the dotfiles repo"
			echo "Please manually migrate any config from the .zshenv file in the home directory"
		fi
	else
		echo "No .zshenv file found in the home directory or dotfiles repo"
		echo "Creating a new .zshenv file in the dotfiles repo"
		touch "$SCRIPT_DIRECTORY"/.zshenv
	fi
fi

unset _home_zshenv _home_zshenv_link _dot_zshenv

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
