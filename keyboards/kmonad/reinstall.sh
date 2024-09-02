#!/bin/bash

script_dir="$(dirname -- "$(readlink -f -- "$0")")"

echo "Copying over the internal keyboard to /etc/kmonad"
sudo mkdir -p /etc/kmonad
sudo cp $script_dir/internal.kbd /etc/kmonad/default.kbd
