#!/bin/bash

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

rm "$SCRIPT_DIRECTORY"/brew/Brewfile
brew bundle dump --file="$SCRIPT_DIRECTORY"/brew/Brewfile