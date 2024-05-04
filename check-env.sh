#!/bin/zsh

echo "Verifying environment..."
source "$HOME/.zshrc"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

check_commands=(
  # shell essentials
  zsh
  git
  sudo
  ps
  # core tools
  parallel
  clang
  # net tools
  curl
  wget
  openssl
  # dev tools
  tmux
  rg
  fzf
  nvim
  lazygit
  delta
  stow
  # languages
  flutter
  dart
  go
  node
  npm
  cmake
  uv
  python
   # bonus tools
  gh
  jq
)

missing=""
for cmd in ${check_commands[@]}; do
  if ! command_exists "$cmd"; then
    missing="$missing $cmd "
  fi
done

if [ -n "$missing" ]; then
  echo "Missing the following commands:"
  echo "$missing" | xargs -I% echo %
fi

echo "Done checking environment"
