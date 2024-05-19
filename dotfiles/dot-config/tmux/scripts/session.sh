#!/bin/bash

switch_session() {
  tmux ls -F '#S' |
    fzf --header switch-session --preview 'tmux capture-pane -pt {}' |
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

switch_or_add_session() {
  selected=$(
    (
      find "$HOME/src" "$HOME/dev" -mindepth 0 -maxdepth 2 -type d
      echo "$HOME/.dotfiles"
    ) |
      fzf --scheme=path --tiebreak=end,index --header "Open tmux session"
  )
  [ -z $selected ] && return
  name=$(basename $selected)

  echo $selected

  if [ -z $TMUX ]; then
    tmux new-session -Ac $selected -s $name
    return
  fi

  tmux switch-client -t $name ||
    tmux new-ses -APdc $selected -s $name | xargs tmux switch-client -t
}

delete_session() {
  tmux ls -F '#S' |
    fzf --header delete-session --preview 'tmux capture-pane -pt {}' |
    xargs tmux kill-session -t
}
