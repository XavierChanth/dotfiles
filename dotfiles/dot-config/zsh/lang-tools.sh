#!/bin/zsh

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if command -v lazygit >/dev/null 2>&1; then
  alias lg='lazygit'
fi

if command -v yazi >/dev/null 2>&1; then
  alias y='yazi'
fi
