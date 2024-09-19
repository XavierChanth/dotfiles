#!/bin/bash

function add_session() {
  selected="$1"
  [ -z $selected ] && return

  name="$2"
  if [ -z "$name" ]; then
    name=$(basename $selected)
  fi
  command="$3"
  tmuxcommand="$4"

  tmux if-shell -F '#{==:#{pane_mode},tree-mode}' 'send q'
  session=$(tmux new-ses -Pc $selected -s $name || printf $name)

  if [ -n $tmuxcommand ]; then
    tmux send-prefix -t $session
    tmux send-keys -t $session : "$tmuxcommand" Enter
  fi

  if [ -n $command ]; then
    tmux send-keys -t $session $command C-m C-l
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
  command="ssh $selected"

  # TODO: fix command
  add_session "$selected" "$name" # "$command"
}
