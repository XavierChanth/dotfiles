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

docker_session() {
  selected=$(docker ps --all --format "table {{.Names}}" | fzf)
  [-z $selected ] && return

  name=$(basename $selected)
  docker start $selected

  if [ -z $TMUX ]; then
    tmux new-ses -Ac $selected -s $name
    return
  fi

  tmux switch-client -t $name ||
    tmux new-ses -AdPc $selected -s $name docker exec -it $name /bin/zsh | xargs tmux switch-client -t
}

ssh_session() {

  hostname=$(
    (
      echo ""
      grep -E "^Host ([^*]+)$" $HOME/.ssh/config | sed 's/Host //'
    ) | fzf --header "Host"
  )

  if [ -z "$hostname" ]; then
    echo "Enter custom hostname:"
    read hostname
  fi

  jumpbox=$(
    (
      echo ""
      grep -E "^Host ([^*]+)$" $HOME/.ssh/config | sed 's/Host //'
    ) | fzf --header "Jumpbox"
  )

  echo "Additional args:"
  read args

  if [ -n "$jumpbox" ]; then
    command="ssh $USER@$hostname -J $jumpbox"
  else
    command="ssh $USER@$hostname"
  fi

  if [ -z $TMUX ]; then
    tmux new-ses -As $hostname -e "TMUX_SSH_COMMAND='$command'" "$command"
    return
  fi

  # FIXME:
  tmux new-ses -e "TMUX_SSH_COMMAND=$command" -AdPs "$hostname" "$command" | xargs tmux switch-client -t
}
