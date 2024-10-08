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
  cd "$script_dir"
  qmk config user.overlay_dir="$(realpath qmk)"
  cd "$script_dir/qmk_firmware";
  qmk setup
  qmk userspace-remove -kb 'all'
  qmk config user.qmk_home="$script_dir/qmk_firmware"
}

# xavierchanth/qmk_firmware branch: xavierchanth
qmk_air75() {
  (qmk_init
    git switch xavierchanth || return 1
  qmk compile -kb nuphy/air75_v2/ansi -km xavierchanth)
}

# zsa/qmk_firmware branch: firmware24
qmk_voyager() {
  (qmk_init
  git switch firmware24
  qmk compile -kb voyager -km xavierchanth)
}
