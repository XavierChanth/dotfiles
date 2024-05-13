#!/bin/bash

# you probably think this is dumb right?
# well... it actually does something really cool
# it makes it so that you can use sudo with other aliases
alias sudo='sudo '

alias ls='ls --color'
alias ll='ls -lh'
alias la='ls -lah'

alias x64='arch -x86_64'
alias s='source $HOME/.zshenv && source $HOME/.zshrc'
alias q='exit'

alias v='nvim'
alias vv='cc; nvim'

alias t='tmux'
alias tt='source $XDG_CONFIG_HOME/tmux/scripts/session.sh && switch_or_add_session'

alias td='__tt_selected=$(docker ps --all --format "table {{.Names}}" | fzf) || return 1 &&
  docker start $__tt_selected &&
  [ -z $TMUX ] && tmux new-ses -Ac $__tt_selected -s $(basename $__tt_selected) ||
  tmux switch-client -t $(basename $__tt_selected) ||
  tmux new-ses -AdPc $__tt_selected -s $(basename $__tt_selected) docker exec -it $(basename $__tt_selected) /bin/zsh | xargs tmux switch-client -t'

if [ "$(uname)" = 'Darwin' ]; then
  alias net='open "x-apple.systempreferences:com.apple.preference.network"'
fi
