#!/bin/bash

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

# Symbolic link zsh config
ln -s "$SCRIPT_DIRECTORY"/.zshrc  "$HOME"/.zshrc


curl -fsSL git.io/antigen > "$SCRIPT_DIRECTORY"/xavierchanth/antigen.zsh

ln -s "$SCRIPT_DIRECTORY"/xavierchanth  "$HOME"/.config/xavierchanth
ln -s "$SCRIPT_DIRECTORY"/nvim "$HOME"/.config/nvim
