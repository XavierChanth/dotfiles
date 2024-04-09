#!/bin/zsh

alias glog='git log --oneline --decorate --graph'
alias gloga='glog --all'
alias lg='lazygit'

clone() {
  REPO=$1
  shift;

  if [[ $REPO =~ ^(git@github\.com:.*|https:\/\/github\.com\/.*)$ ]]; then
    prefix=""
  else
    prefix="git@github.com:"
  fi

  git clone "$prefix$REPO" "$@"
}

