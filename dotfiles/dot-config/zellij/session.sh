#!/bin/bash

add_session() {
  selected=$(
    (
      find "$HOME/src" "$HOME/dev" -mindepth 0 -maxdepth 2 -type d
      echo "$HOME/.dotfiles"
    ) |
      fzf --scheme=path --tiebreak=end,index --header "Open zellij session"
  )
  [ -z $selected ] && return
  name=$(basename $selected)
  (
    cd $selected
    zellij attach --create $name
  )
}
