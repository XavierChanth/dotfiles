#!/bin/bash

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

_brew_file="$SCRIPT_DIRECTORY"/.xavierchanth/brew/Brewfile
rm "$_brew_file"
brew bundle dump --file="$_brew_file"
