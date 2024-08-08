#!/bin/bash

get_current_session() {
  tmux list-panes -t "$TMUX_PANE" -F '#S' | head -n1
}

switch_session() {
  current=$(get_current_session)
  tmux ls -F '#S' |
    grep -v "^$current\$" |
    fzf --header "Switch tmux session" --preview 'tmux capture-pane -pt {}' |
    xargs -I % tmux switch-client -t '%'
}

add_session() {
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

delete_session() {
  selected=$(
    tmux ls -F '#S' |
      fzf --header "!!! DELETE tmux session !!!" --preview 'tmux capture-pane -pt {}'
  )
  current=$(get_current_session)

  [ -z $selected ] && return
  [ -z $current ] && return

  if [ "$selected" = "$current" ]; then
    switch_session
  fi

  tmux kill-session -t $selected
}
