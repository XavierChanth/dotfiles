#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

case "$(uname)" in
  Darwin)
    if command_exists dnf; then
      echo "brew package manager found, installing packages for brew"

      # core apps
      brew install <<EOF
        librewolf google-chrome
        zoom discord spotify
        betterdisplay cleanshot unnaturalscrollwheels
      EOF
      # desktop essentials
      brew tap felixkratz/formulae
      brew install <<EOF
        aerospace sketchybar raycast
      EOF
      # terminal stuff
      brew install <<EOF
        wezterm asciinema
        font-jetbrains-mono-nerd-font
        aerc abook
        yazi ffmpegthumbnailer unar poppler
      EOF
    fi
    ;;
  Linux)
    if command_exists dnf; then
      echo "dnf package manager found, installing packages for dnf"

      sudo dnf install wezterm
      sudo dnf install aerc abook
    fi

    # TODO: install yazi
    ;;
esac