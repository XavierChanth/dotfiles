#!/bin/bash

script_dir="$(dirname -- "$(readlink -f -- "$0")")"

git clone --recursive https://github.com/kmonad/kmonad.git $script_dir/.kmonad

ln -s $script_dir/../../../macos/Library/LaunchAgents/xyz.xavierchanth.kmonad.plist

cd $script_dir/.kmonad || exit 1
open c_src/mac/Karabiner-DriverKit-VirtualHIDDevice/dist/Karabiner-DriverKit-VirtualHIDDevice-3.1.0.pkg

echo "Press enter to continue"
read

/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate

echo "Press enter to continue"
read

brew install stack haskell-stack
stack init
stack build --flag kmonad:dext --extra-include-dirs=c_src/mac/Karabiner-DriverKit-VirtualHIDDevice/include/pqrs/karabiner/driverkit:c_src/mac/Karabiner-DriverKit-VirtualHIDDevice/src/Client/vendor/include
