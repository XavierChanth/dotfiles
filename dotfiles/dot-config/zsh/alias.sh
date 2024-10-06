#!/bin/zsh

# you probably think this is dumb right?
# well... it actually does something really cool
# it makes it so that you can use sudo with other aliases
alias sudo='sudo '

alias ls='ls --color'
alias cat='bat'

alias x64='arch -x86_64'
alias s='source $HOME/.zshenv && source $HOME/.zshrc'
alias q='exit'

alias v='nvim'

t() {
  if [ $# -gt 0 ]; then
    tmux $@
  else
    tmux new -A -s 'main'
  fi
}

if command -v lazygit >/dev/null 2>&1; then
  alias lg='lazygit'
fi

if command -v yazi >/dev/null 2>&1; then
  alias y='yazi'
fi

if [ "$(uname)" = 'Darwin' ]; then
  alias net='open "x-apple.systempreferences:com.apple.preference.network"'
fi
