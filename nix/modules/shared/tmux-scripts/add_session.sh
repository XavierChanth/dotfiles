#!/usr/bin/env bash

function add_session() {
  selected="$1"
  [ -z $selected ] && return

  name="$2"
  if [ -z "$name" ]; then
    case "$selected" in
      */work/*)
        work_path="${selected#*"/work/"}"
        name="w/$(printf '%s' "$work_path" | sed -e 's/\./_/g')"
        ;;
      *)
        name=$(basename "$selected" | sed -e 's/\./_/g')
        ;;
    esac
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
