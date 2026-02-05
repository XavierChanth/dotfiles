#!/usr/bin/env bash

script_dir="$(dirname -- "$(readlink -f -- "$0")")"
target="$script_dir/$1"

if ! [ -d "$target" ]; then
  echo "$1" is not a skill in this directory.
  exit 1
fi

ln -sf "$target" "$script_dir/../dotfiles/dot-claude/skills"
ln -sf "$target" "$script_dir/../dotfiles/dot-codex/skills"
ln -sf "$target" "$script_dir/../dotfiles/dot-config/opencode/skills"

