#!/bin/zsh

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
alias c='cd $(find . -type d | fzf || echo ".")'

alias dl='mkdir .local; echo "**" > .local/.gitignore'

t() {
  if [ $# -gt 0 ]; then
    tmux $@
  else
    tmux new -A -s 'main'
  fi
}
alias tt='source $XDG_CONFIG_HOME/tmux/scripts/session.sh && fzf_session'
alias td='source $XDG_CONFIG_HOME/tmux/scripts/session.sh && ssh_session'
alias tl='source $XDG_CONFIG_HOME/tmux/scripts/layout.sh && run_layout'

if command -v lazygit >/dev/null 2>&1; then
  alias lg='lazygit'
fi

if command -v yazi >/dev/null 2>&1; then
  alias y='yazi'
fi

if command -v aerc >/dev/null 2>&1; then
  alias a='aerc'
fi

# not using zellij rn
# alias z='zellij'
# alias zz='source $XDG_CONFIG_HOME/zellij/session.sh && add_session'
# alias zl='source $XDG_CONFIG_HOME/zellij/layout.sh && run_local'

if [ "$(uname)" = 'Darwin' ]; then
  alias net='open "x-apple.systempreferences:com.apple.preference.network"'
fi
