#!/usr/bin/env bash

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "$script_dir/.." && pwd)

host="${1}"
[ -z "$host" ] && host="nyx"

if [ "$(uname)" = "Darwin" ]; then
  sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin \
    -- switch --flake "path:$repo_root#$host"
fi
