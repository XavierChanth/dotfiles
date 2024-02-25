#!/bin/bash

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

# check if brew is installed
if ! command -v brew &>/dev/null; then
	echo "brew could not be found"
	echo "install brew from https://brew.sh/"
	exit
fi
brew bundle --file="$SCRIPT_DIRECTORY"/.xavierchanth/brew/Brewfile

# zsh - setup non-committed files
curl -fsSL git.io/antigen >"$SCRIPT_DIRECTORY"/.config/zsh/antigen.zsh
touch "$SCRIPT_DIRECTORY"/.config/zsh/secrets.sh

# stow
if ! command -v stow &>/dev/null; then
	echo "brew could not be found"
	echo "install brew from https://brew.sh/"
	exit
fi
stow -d "$SCRIPT_DIRECTORY" -t "$HOME" .

# iterm2 - must use their weird way of loading config files
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.xavierchanth/iterm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
