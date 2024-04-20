#!/bin/bash

echo "Verifying environment..."
source "$HOME/.zshrc"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# create a here doc for commands list
commands=(
  # core
  zsh
  git
  sudo
  curl
  wget
  ps
  openssl
  parallel
  # dev
  stow
  tmux
  rg
  fzf
  nvim
  lazygit
  delta
  # tools
  jq
  uv
  vfox
  # languages (installed with vfox)
  flutter
  dart
  go
  node
  npm
  cmake
  python
)

missing=""
for cmd in ${commands[@]}; do
  if ! command_exists "$cmd"; then
    missing="$cmd "
  fi
done

if [ -n "$missing" ]; then
  echo "Missing the following commands:"
  echo "$missing" | xargs -I% echo %
fi

echo "Done checking environment"
