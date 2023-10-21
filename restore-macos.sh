#!/bin/bash

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

# check if brew is installed
if ! command -v brew &> /dev/null
then
    echo "brew could not be found"
    echo "install brew from https://brew.sh/"
    exit
fi

if [ ! -f "$SCRIPT_DIRECTORY/confirmed_overwrite" ]; then
    echo "This script could potentially overwrite your existing dotfiles."
    echo "Are you sure you want to continue? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
        echo "Exiting..."
        exit
    fi
    touch "$SCRIPT_DIRECTORY/confirmed_overwrite"
fi

# zsh
ln -sfh "$SCRIPT_DIRECTORY"/.zshrc  "$HOME"/.zshrc
touch "$SCRIPT_DIRECTORY"/zsh/secrets.sh
ln -sFh "$SCRIPT_DIRECTORY"/zsh  "$HOME"/.config/zsh

# antigen
curl -fsSL git.io/antigen > "$HOME"/.config/zsh/antigen.zsh

# install from brewfile
brew bundle --file="$SCRIPT_DIRECTORY"/brew/Brewfile

# nvim
ln -sFh "$SCRIPT_DIRECTORY"/nvim "$HOME"/.config/nvim

# iterm 2
ln -sfh "$SCRIPT_DIRECTORY"/iterm2/switch_automatic.py "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"

# vscode
ln -sfh "$SCRIPT_DIRECTORY"/vscode/settings.json "$HOME/Library/Application Support/Code/User"
ln -sfh "$SCRIPT_DIRECTORY"/vscode/keybindings.json "$HOME/Library/Application Support/Code/User"
