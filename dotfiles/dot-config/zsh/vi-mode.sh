#!/bin/bash

export EDITOR="nvim"
export VISUAL="nvim"

bindkey -v          # vi-mode in zsh
export KEYTIMEOUT=1 # decrease the delay

_block='\e[1 q'
_beam='\e[5 q'

# vi-mode init (start in insert mode with beam cursor)
zle-line-init() {
  zle -K viins
  echo -ne $_beam
}
zle -N zle-line-init # register init

zle-keymap-select() { # change cursor when swapping keymaps
  case $KEYMAP in
    vicmd) echo -ne $_block ;;
    viins | main) echo -ne $_beam ;;
  esac
}
zle -N zle-keymap-select # register keymap select

# Some common zle widgets which I accidentally type
w() {
  zle accept-line
}
zle -N w

wq() {
  zle accept-line
}
zle -N wq
