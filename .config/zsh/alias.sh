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

alias find_projects="{find $HOME/src $HOME/dev -mindepth 0 -maxdepth 2 -type d; echo "$HOME/.dotfiles"}"
alias fzf_projects='find_projects | fzf --scheme=path --tiebreak=end,index'
alias fzf_project='fzf_projects' # idk why but cc is truncating the last char in cc alias so...
alias cc='__cc_selected=$(fzf_projects) || return 1 && cd $__cc_selected'

alias v='nvim'
alias vv='cc; nvim'

alias t='tmux' 
alias tt='__tt_selected=$(fzf_projects) || return 1 &&
  [ -z $TMUX ] && tmux new-ses -Ac $__tt_selected -s $(basename $__tt_selected) ||
  tmux switch-client -t $(basename $__tt_selected) ||
  tmux new-ses -AdPc $__tt_selected -s $(basename $__tt_selected) | xargs tmux switch-client -t'

alias td='__tt_selected=$(docker ps --all --format "table {{.Names}}" | fzf) || return 1 &&
  docker start $__tt_selected &&
  [ -z $TMUX ] && tmux new-ses -Ac $__tt_selected -s $(basename $__tt_selected) ||
  tmux switch-client -t $(basename $__tt_selected) ||
  tmux new-ses -AdPc $__tt_selected -s $(basename $__tt_selected) docker exec -it $(basename $__tt_selected) /bin/zsh | xargs tmux switch-client -t'

if $is_darwin; then
  alias net='open "x-apple.systempreferences:com.apple.preference.network"'
fi

