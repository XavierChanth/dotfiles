#!/usr/bin/env bash

host="${1}"
[ -z "$host" ] && host="nyx"

if [ "$(uname)" = "Darwin" ]; then
  sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin \
    -- switch --flake "path:/Users/chant/.dotfiles#$host"
fi
