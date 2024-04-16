#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# create a here doc for commands list
read -r commands <<EOF
git
sudo
curl
zsh
tmux
ripgrep
fzf
nvim
openssl
asdf
gh
stow
lazygit
ps
delta
EOF

for cmd in $commands; do
  if ! command_exists "$cmd"; then
    echo "Error: $cmd is not installed"
  fi
done

echo "Done checking environment"
