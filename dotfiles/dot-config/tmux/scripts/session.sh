#!/bin/bash

function add_session() {
  selected=$(
    (
      find "$HOME/src" "$HOME/dev" -mindepth 0 -maxdepth 2 -type d
      echo "$HOME/.dotfiles"
    ) |
      fzf --scheme=path --tiebreak=end,index --header "Open tmux session"
  )
  [ -z $selected ] && return
  name=$(basename $selected)

  if [ -z $TMUX ]; then
    tmux new-session -Ac $selected -s $name
    return
  fi

  tmux new-ses -APdc $selected -s $name | xargs tmux switch-client -t
}
