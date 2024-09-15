#!/bin/bash

function fzf_session() {
  selected=$(
    (
      find "$HOME/src" "$HOME/dev" -mindepth 0 -maxdepth 2 -type d
      echo "$HOME/.dotfiles"
    ) |
      fzf --scheme=path --tiebreak=end,index --header "Open tmux session"
  )

  [ -z $selected ] && return
  name=$(basename $selected)
  tmux if-shell -F '#{==:#{pane_mode},tree-mode}' 'send q'
  session=$(tmux new-ses -APdc $selected -s $name)

  if [ -z $TMUX ]; then
    tmux attach -t $session
  else
    tmux switch-client -t $session
  fi
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

  tmux if-shell -F '#{==:#{pane_mode},tree-mode}' 'send q'
  session=$(tmux new-ses -APdc $selected -s $name)
  tmux send-keys -t $session $command C-l C-m

  if [ -z $TMUX ]; then
    tmux attach -t $session
  else
    tmux switch-client -t $session
  fi

}
