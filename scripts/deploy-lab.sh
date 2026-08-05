#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  echo "usage: $0 HOST {build|dry-activate|test|boot|switch}" >&2
}

if [[ ${1:-} == -h || ${1:-} == --help ]]; then
  usage
  exit 0
fi

if (($# != 2)); then
  usage
  exit 64
fi

host=$1
action=$2

[[ $host =~ ^[a-z][a-z0-9-]*$ ]] || {
  echo "deploy-lab: invalid host name: $host" >&2
  usage
  exit 64
}

case $action in
  build) elevate=0 ;;
  dry-activate | test | boot | switch) elevate=1 ;;
  *)
    echo "deploy-lab: unsupported action: $action" >&2
    usage
    exit 64
    ;;
esac

repo=$(cd "$(dirname "$0")/.." && pwd -P)
flake="path:$repo"

configured_host=$(nix eval --raw --no-write-lock-file \
  "$flake#nixosConfigurations.$host.config.networking.hostName" 2>/dev/null) || {
  echo "deploy-lab: unsupported NixOS host: $host" >&2
  usage
  exit 64
}
[[ $configured_host == "$host" ]] || {
  echo "deploy-lab: configuration hostname mismatch: expected $host, got $configured_host" >&2
  exit 1
}

args=(
  "$action"
  --flake "$flake#$host"
  --build-host "$host"
  --target-host "$host"
  --no-write-lock-file
  --use-substitutes
)

if ((elevate)); then
  # nixos-rebuild prompts locally and passes the password directly to remote
  # sudo over its activation channel. The repository never handles it.
  args+=(--ask-sudo-password)
fi

exec nix run \
  --no-write-lock-file \
  --inputs-from "$repo" \
  nixpkgs#nixos-rebuild \
  -- "${args[@]}"
