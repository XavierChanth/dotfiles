#!/bin/bash

export EDITOR="nvim"
export VISUAL="nvim"

set -o vi

# credit: https://www.reddit.com/r/vim/comments/mxhcl4/setting_cursor_indicator_for_zshvi_mode_in/
function zle-keymap-select () {
case $KEYMAP in
  vicmd) echo -ne '\e[1 q';; # block
  viins|main) echo -ne '\e[5 q';; # beam
esac
}

zle-line-init() {
  zle -K viins
  echo -ne "\e[5 q"
}

zle -N zle-keymap-select
zle -N zle-line-init


preexec() { echo -ne '\e[5 q' }


