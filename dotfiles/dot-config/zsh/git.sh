#!/bin/bash

alias glog='git log --oneline --decorate --graph'
alias gloga='glog --all'
alias lg='lazygit'

alias iswt='git rev-parse --is-inside-work-tree'
alias gwt='git worktree list --porcelain | rg $(git branch --show-current) | rg ^worktree | cut -d' ' -f 2'

clone() {
  REPO=$1
  shift

  if [[ $REPO =~ ^(git@github\.com:.*|https:\/\/github\.com\/.*)$ ]]; then
    prefix=""
  else
    prefix="git@github.com:"
  fi

  git clone "$prefix$REPO" "$@"
}

# git clone bare
gcb() {
  REPO=$1
  shift

  if [[ $REPO =~ ^(git@github\.com:.*|https:\/\/github\.com\/.*)$ ]]; then
    prefix=""
  else
    prefix="git@github.com:"
  fi

  git cb "$prefix$REPO" "$@"
}
