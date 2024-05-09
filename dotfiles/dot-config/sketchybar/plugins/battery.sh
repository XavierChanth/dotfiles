#!/usr/bin/env sh

# Battery is here bcause the ICON_COLOR doesn't play well with all background colors

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
  [8-9][0-9] | 100)
    ICON=""
    ;;
  7[0-9])
    ICON=""
    ;;
  [4-6][0-9])
    ICON=""
    ;;
  [1-3][0-9])
    ICON=""
    ;;
  [0-9])
    ICON=""
    ;;
esac

if [[ $CHARGING != "" ]]; then
  ICON=""
fi

sketchybar --set $NAME \
  label="${PERCENTAGE}%" \
  --set "$NAME".icon \
  icon=$ICON