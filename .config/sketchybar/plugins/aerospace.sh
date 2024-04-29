#!/usr/bin/env bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.color=0xfff5a97f
else
  sketchybar --set $NAME background.color=0xff89b4fa
fi
