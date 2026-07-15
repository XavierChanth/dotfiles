#!/usr/bin/env bash
set -euo pipefail

retention_days=7

for command_name in nix-collect-garbage brew; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Required command not found: $command_name" >&2
    exit 1
  fi
done

echo "Removing Nix profile generations older than ${retention_days} days, then collecting unreachable store paths..."
sudo nix-collect-garbage --delete-older-than "${retention_days}d"

echo "Removing Homebrew cache files older than ${retention_days} days..."
brew cleanup --prune="$retention_days"
