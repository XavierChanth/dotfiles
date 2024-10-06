#!/bin/zsh

bindkey -v          # vi-mode in zsh
export KEYTIMEOUT=1 # decrease the delay

local block='\e[1 q'
local beam='\e[5 q'

local mode="I"
local color="green"

function spaceship_mode() {
  spaceship::section::v4 \
    --color "$color" \
    --prefix "" \
    --suffix " " \
    "$mode"
}
# Override default keymap-select
function zle-keymap-select() { # change cursor when swapping keymaps
  case $KEYMAP in
    vicmd)
      echo -ne $block
      mode="N"
      color="blue"
      ;;
    viins | main)
      echo -ne $beam
      mode="I"
      color="green"
      ;;
  esac
  # refresh spaceship when we change modes
  spaceship::core::refresh_section "mode" ; zle .reset-prompt
}

# Override default line-init
function zle-line-init() {
  zle -K viins # Start in insert keymap
  # Start with beam cursor
  echo -ne $beam
}

# Yank to system
# Don't override, because we still want all the nice default behaviors
function vi-yank {
  zle .vi-yank
  if [ "$(uname)" = 'Darwin' ]; then
    printf "$CUTBUFFER" | pbcopy
  else
    printf "$CUTBUFFER" | xclip -i
  fi
  zle -K viins
}

# Because vim things happen
function w() {
  zle accept-line
}
function wq() {
  zle accept-line
}
function q() {
  zle kill-buffer
}

# Register all zle functions declared
zle -N zle-line-init
zle -N zle-keymap-select
zle -N vi-yank
zle -N w
zle -N wq
zle -N q
