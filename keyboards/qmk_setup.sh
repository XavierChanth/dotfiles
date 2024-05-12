#!/bin/bash

script_dir="$(dirname -- "$(readlink -f -- "$0")")"

qmk config user.keyboard=nuphy/air75_v2/ansi
qmk config user.keymap=xavierchanth
qmk config user.qmk_home="$script_dir"/qmk_firmware

(
  cd "$script_dir"/qmk_firmware
  git submodule update --init --recursive
)

qmk setup
