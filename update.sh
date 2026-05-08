#!/usr/bin/env bash
set -euo pipefail

nix flake update
./build.sh
