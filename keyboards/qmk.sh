#!/bin/bash

# https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
(
  [[ -n $ZSH_VERSION && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
  [[ -n $KSH_VERSION && "$(cd -- "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")" != "$(cd -- "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")" ]] || 
  [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)
) && sourced=1 || sourced=0

if [ $sourced -eq 0 ]; then
  echo "This script is meant to be sourced, do not run directly"
  echo "You will have the following commands available:"
  echo "qmk_update, qmk_air75, qmk_voyager"
  exit 0
fi

script_dir="$(dirname -- "$(readlink -f -- "$0")")"

# Must be in the dir before trying to set the overlay_dir
qmk_init() {
  (
    cd "$script_dir/qmk" || return 1
    qmk config user.overlay_dir="$(realpath .)"
  )
}

qmk_init

# Note ZSA uses a separate repo to manage their keyboards so typical build methods will not work.
# Use these helper scripts instead of following the docs
qmk_update() {
  (
    cd "$script_dir" || return 1
    git submodule update --init --recursive qmk
    git submodule update --init --recursive zsa_firmware
  ) || return 1
  qmk setup
}

# Waiting eons for https://github.com/qmk/qmk_firmware/pull/22751
# Good thing I don't intend to flash this board any time soon
qmk_air75() {
  qmk_init
  qmk userspace-remove -kb 'all'
  qmk config user.qmk_home="$script_dir/qmk_firmware"
  qmk userspace-add -kb nuphy/air75_v2/ansi -km xavierchanth
  qmk userspace-compile
}

qmk_voyager() {
  qmk_init
  qmk userspace-remove -kb 'all'
  qmk config user.qmk_home="$script_dir/zsa_firmware"
  qmk userspace-add -kb voyager -km xavierchanth
  qmk userspace-compile
}
