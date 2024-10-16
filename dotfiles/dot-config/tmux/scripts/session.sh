#!/bin/bash

function add_session() {
  selected="$1"
  [ -z $selected ] && return

  name="$2"
  if [ -z "$name" ]; then
    name=$(basename $selected | sed -e 's/\./_/g')
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
      # tested find against fd, for a small set of directories like this find is slightly faster
      # now, if you were recursively searching all files, fd wins by a mile
      find "$HOME/src" -mindepth 0 -maxdepth 2 -type d
      # fd . "$HOME/src" "$HOME/dev" --min-depth 0 -d 2 -t dir
      echo "$HOME/.dotfiles"
      echo "main"
    ) |
      fzf --scheme=path --tiebreak=end,index --header "Open tmux session"
  )
  add_session "$selected"
}

function ssh_session() {
  includes=$(cat "$HOME/.ssh/config" | rg 'Include ' | cut -d ' ' -f2 | sed -e "s|^|$HOME/.ssh/|")
  files=$(printf $includes | xargs -I % /bin/sh -c 'ls %' && echo "$HOME/.ssh/config")
  hosts=$(echo $files | xargs -I % /bin/sh -c 'cat "%" | grep "Host " | grep -v "Host \*" | cut -d " " -f2')

  selected=$(
    echo $hosts |
      fzf --scheme=path --tiebreak=end,index --header "Open tmux session"
  )

  [ -z $selected ] && return

  name="ssh-$selected"
  # add sshnp to path so it works in ProxyCommands
  command="PATH='$PATH:$HOME/.local/bin'; ssh $selected"

  add_session "$selected" "$name" "$command"
}
