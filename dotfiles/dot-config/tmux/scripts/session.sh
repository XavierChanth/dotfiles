#!/bin/bash

function add_session() {
  selected="$1"
  [ -z $selected ] && return

  name="$2"
  if [ -z "$name" ]; then
    name=$(basename $selected)
  fi

  command="$3"

  tmux if-shell -F '#{==:#{pane_mode},tree-mode}' 'send q'
  if [ -n "$command" ]; then
    session=$(tmux new-ses -dPF "#S" -c $selected -s $name "$command")
    tmux set -t "$session" default-command "$command"
  else
    session=$(tmux new-ses -dPF "#S" -c $selected -s $name || printf $name)
  fi

  if [ -z $TMUX ]; then
    tmux attach -t $session
  else
    tmux switch-client -t $session
  fi
}

function fzf_session() {
  selected=$(
    (
      find "$HOME/src" "$HOME/dev" -mindepth 0 -maxdepth 2 -type d
      echo "$HOME/.dotfiles"
    ) |
      fzf --scheme=path --tiebreak=end,index --header "Open tmux session"
  )
  add_session "$selected"
}

function ssh_session() {
  selected=$(
    (
      cat $HOME/.ssh/config | grep 'Host ' | grep -v 'Host \*' | cut -d ' ' -f2
    ) |
      fzf --scheme=path --tiebreak=end,index --header "Open tmux session"
  )

  [ -z $selected ] && return

  name="ssh-$selected"
  # add sshnp to path so it works in ProxyCommands
  command="PATH='$PATH:$HOME/.local/bin'; ssh $selected"

  add_session "$selected" "$name" "$command"
}
