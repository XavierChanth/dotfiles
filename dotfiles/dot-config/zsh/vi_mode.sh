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
  spaceship::core::refresh_section "mode"
  zle .reset-prompt && zle -R
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
  elif [ "$(uname)" = 'Linux' ]; then
    case "$XDG_SESSION_TYPE" in
    wayland) printf "$CUTBUFFER" | wl-copy ;;
    x11) printf "$CUTBUFFER" | xclip -i ;;
    esac
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

if [ "$(uname)" = 'Darwin' ]; then
  cmd='pb'
elif [ -n "$WAYLAND_DISPLAY" ]; then
  cmd='wl'
else
  cmd='x'
fi

# Setup copy and paste
function clip-wrap-widgets() {
  # NB: Assume we are the first wrapper and that we only wrap native widgets
  # See zsh-autosuggestions.zsh for a more generic and more robust wrapper
  local copy_or_paste=$1
  shift

  for widget in $@; do
    # Ugh, zsh doesn't have closures
    local set_widget=true
    case "$cmd-$copy_or_paste" in
    pb-copy)
      eval "
            function _clip-wrapped-$widget() {
                zle .$widget
                pbcopy <<<\$CUTBUFFER
            }
           "
      ;;
    pb-paste)
      eval "
            function _clip-wrapped-$widget() {
                CUTBUFFER=\$(pbpaste)
                zle .$widget
            }
            "
      ;;
    wl-copy)
      eval "
            function _clip-wrapped-$widget() {
                zle .$widget
                wl-copy <<<\$CUTBUFFER
            }
           "
      ;;
    wl-paste)
      eval "
            function _clip-wrapped-$widget() {
                CUTBUFFER=\$(wl-paste)
                zle .$widget
            }
            "
      ;;
    x-copy)
      eval "
            function _clip-wrapped-$widget() {
                zle .$widget
                xclip -in -selection clipboard <<<\$CUTBUFFER
            }
           "
      ;;
    x-paste)
      eval "
            function _clip-wrapped-$widget() {
                CUTBUFFER=\$(xclip -out -selection clipboard)
                zle .$widget
            }
            "
      ;;
    *) set_widget=false ;;
    esac
    if [[ $copy_or_paste == "copy" ]]; then
    else
    fi

    if $set_widget; then
      zle -N $widget _clip-wrapped-$widget
    fi
  done
}

local copy_widgets=(
  vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line
)
local paste_widgets=(
  vi-put-{before,after}
)

# NB: can atm. only wrap native widgets
clip-wrap-widgets copy $copy_widgets
clip-wrap-widgets paste $paste_widgets
