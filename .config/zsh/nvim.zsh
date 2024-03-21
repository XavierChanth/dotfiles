#!/bin/zsh

export EDITOR="nvim"
export VISUAL="nvim"

alias v='nvim'
alias vi='nvim'
alias vim='nvim'

vv() {
  if ! c; then
    return 1
  fi
  DISABLE_AUTO_TITLE="true" echo -e "\033];nvim - $selected\007"
  nvim;
  DISABLE_AUTO_TITLE="false"
  return 0
}



