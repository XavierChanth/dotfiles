#!/bin/sh
while true; do
    if grep -q "closed" /proc/acpi/button/lid/*/state; then
        # Check if external display is connected
        if ! swaymsg -t get_outputs | grep -q "HDMI-A-1.*enabled"; then
            # No external display, lock the screen
            swaylock -f
        fi
    fi
    sleep 2
done
