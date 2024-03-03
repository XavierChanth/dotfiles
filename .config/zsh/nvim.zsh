#!/bin/zsh

export EDITOR="nvim"
export VISUAL="nvim"

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
vv() {
  selected=$(find $HOME/src/af $HOME/src/ac $HOME/src/xc $HOME/src/sa -mindepth 1 -maxdepth 1 -type d | fzf)
  if [ -z "$selected" ]; then
    return
  fi
  cd $selected;
  DISABLE_AUTO_TITLE="true" echo -e "\033];nvim - $selected\007"
  nvim;
  DISABLE_AUTO_TITLE="false"
}



