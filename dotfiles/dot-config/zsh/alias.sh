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

alias dl='mkdir .local; echo "**" > .local/.gitignore'

alias z='zellij'
alias zz='source $XDG_CONFIG_HOME/zellij/session.sh && add_session'
alias zl='source $XDG_CONFIG_HOME/zellij/layout.sh && run_local'

alias t='tmux'
alias tt='source $XDG_CONFIG_HOME/tmux/scripts/session.sh && switch_or_add_session'
alias td='source $XDG_CONFIG_HOME/tmux/scripts/session.sh && docker_session'
alias tl='source $XDG_CONFIG_HOME/tmux/scripts/layout.sh && run_layout'

if [ "$(uname)" = 'Darwin' ]; then
  alias net='open "x-apple.systempreferences:com.apple.preference.network"'
fi
