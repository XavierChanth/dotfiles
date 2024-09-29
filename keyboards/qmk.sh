#!/bin/bash
script_dir="$(dirname -- "$(readlink -f -- "$0")")"

# Must be in the dir before trying to set the overlay_dir
cd "$script_dir/qmk" || exit 1
qmk config user.overlay_dir="$(realpath .)"
qmk config user.keymap=xavierchanth

# Note ZSA uses a separate repo to manage their keyboards so typical build methods will not work.
# Use these helper scripts instead of following the docs
qmk_update() {
  (
    cd "$script_dir" || exit 1
    git submodule update --init --recursive qmk
    git submodule update --init --recursive zsa_firmware
  ) || exit 1
  qmk setup
}

qmk_air75() {
  qmk config user.qmk_home="$script_dir/qmk_firmware"
  qmk config user.keyboard=nuphy/air75_v2/ansi
  qmk compile
}

qmk_voyager() {
  qmk config user.qmk_home="$script_dir/zsa_firmware"
  qmk config user.keyboard=zsa/voyager
  qmk compile
}
