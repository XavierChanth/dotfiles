#!/bin/bash

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

# Symbolic link zsh config
ln -s "$SCRIPT_DIRECTORY"/.zshrc  "$HOME"/.zshrc

mkdir -p "$HOME"/.config/xavierchanth

curl -fsSL git.io/antigen > "$HOME"/.config/xavierchanth/antigen.zsh

# Checked in files
ln -s "$SCRIPT_DIRECTORY"/xavierchanth/commands.sh  "$HOME"/.config/xavierchanth/commands.sh
ln -s "$SCRIPT_DIRECTORY"/nvim/init.lua "$HOME"/.config/nvim/init.lua

ln -s "$SCRIPT_DIRECTORY"/iterm2/switch_automatic.py "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"

ln -s "$SCRIPT_DIRECTORY"/vscode/settings.json "$HOME/Library/Application Support/Code/User/"
ln -s "$SCRIPT_DIRECTORY"/vscode/keybindings.json "$HOME/Library/Application Support/Code/User/"

# Ignored files
touch "$SCRIPT_DIRECTORY"/xavierchanth/secrets.sh
ln -s "$SCRIPT_DIRECTORY"/xavierchanth/secrets.sh  "$HOME"/.config/xavierchanth/secrets.sh


