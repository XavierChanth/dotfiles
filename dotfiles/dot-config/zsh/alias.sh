#!/bin/zsh

# you probably think this is dumb right?
# well... it actually does something really cool
# it makes it so that you can use sudo with other aliases
alias sudo='sudo '

# alias ls='ls --color'
# alias cat='bat'

alias x64='arch -x86_64'
alias s='source $HOME/.zshenv && source $HOME/.zshrc'
alias q='exit'

alias v='nvim'
alias color="nvim --cmd 'lua vim.g.no_dashboard=true' -c 'lua require(\"util.telescope\").colorscheme({ exit_on_done = true })'"

t() {
  if [ $# -gt 0 ]; then
    tmux $@
  else
    tmux new -A -s 'main'
  fi
}

if [ "$(uname)" = 'Darwin' ]; then
  alias net='open "x-apple.systempreferences:com.apple.preference.network"'
fi

# Get a whole website recursively (-r), including css & js (-p)
# --no-parent ensures you only get this page and everything nested under it
# rather than the whole site
alias wgetsite='wget --no-parent -p -r'

alias lg='lazygit'
alias y='yazi'
function z() {
  [ -n "$1" ] && zed $@ || zed .
}

if ! command -v code >/dev/null 2>&1 && command -v codium >/dev/null 2>&1; then
  alias code="codium"
fi
