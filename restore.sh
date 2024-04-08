#!/bin/bash

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

is_darwin() {
  [ "$(uname)" = 'Darwin' ]
}

while getopts "hb:" opt; do
  case $opt in
    h) echo "Usage: $0 [-bh]" && exit ;;
    b)
      brew=1
      brew_file=$OPTARG
      case $brew_file in
        all | core | apps) ;;
        *)
          echo "Invalid argument for -b"
          echo "  Options: all, core, apps" && exit
          ;;
      esac
      ;;
    *) ;;
  esac
done

if [ "$brew" == 1 ]; then
  if ! command -v brew &>/dev/null; then
    echo "brew could not be found"
    echo "install brew from https://brew.sh/"
    exit
  fi
  case $brew_file in
    all)
      brew bundle --file="$SCRIPT_DIRECTORY"/.xavierchanth/brew/Brewfile
      ;;
    core)
      brew bundle --file="$SCRIPT_DIRECTORY"/.xavierchanth/brew/Brewfile.core
      ;;
    apps)
      brew bundle --file="$SCRIPT_DIRECTORY"/.xavierchanth/brew/Brewfile.apps
      ;;
  esac
fi

# stow
if ! command -v stow &>/dev/null; then
  echo "stow could not be found"
  exit
fi
stow -d "$SCRIPT_DIRECTORY" -t "$HOME" .

if is_darwin; then
  # iterm2 - must use their weird way of loading config files
  if ! [ -f "$HOME"/.iterm2_shell_integration.zsh ]; then
    # install iterm2 shell integration
    # curl -L https://iterm2.com/shell_integration/zsh -o "$HOME"/.iterm2_shell_integration.zsh
  fi
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.xavierchanth/iterm2"
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
fi
