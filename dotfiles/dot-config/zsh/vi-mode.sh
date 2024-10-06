#!/bin/zsh

bindkey -v          # vi-mode in zsh
export KEYTIMEOUT=1 # decrease the delay

_block='\e[1 q'
_beam='\e[5 q'

_mode="I"
_color="green"

function spaceship_mode() {
  spaceship::section::v4 \
    --color "$_color" \
    --prefix "" \
    --suffix " " \
    "$_mode"
}
# Override default keymap-select
function zle-keymap-select() { # change cursor when swapping keymaps
  case $KEYMAP in
    vicmd)
      echo -ne $_block
      _mode="N"
      _color="blue"
      ;;
    viins | main)
      echo -ne $_beam
      _mode="I"
      _color="green"
      ;;
  esac
  # refresh spaceship when we change modes
  spaceship::core::refresh_section "mode" ; zle .reset-prompt && zle -R
}

# Override default line-init
function zle-line-init() {
  zle -K viins # Start in insert keymap
  # Start with beam cursor
  echo -ne $_beam
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
