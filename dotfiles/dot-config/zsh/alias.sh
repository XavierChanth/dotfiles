#!/bin/zsh

# you probably think this is dumb right?
# well... it actually does something really cool
# it makes it so that you can use sudo with other aliases
alias sudo='sudo '

alias x64='arch -x86_64'
alias s='source $HOME/.zshenv && source $HOME/.zshrc'
alias q='exit'

alias v='nvim'
alias c='color'
alias m='aerc'

# provides a fallback set of arguments for the command if no arguments are provided
wrapped_alias() {
  eval "function $1() { if [ \$# -gt 0 ]; then $2 \$@; else $2 $3; fi; }"
}
wrapped_alias "t" "tmux" "new -A -s 'main'"
wrapped_alias "z" "zed" "."

if [ "$(uname)" = 'Darwin' ]; then
  alias net='open "x-apple.systempreferences:com.apple.preference.network"'
fi

# Get a whole website recursively (-r), including css & js (-p)
# --no-parent ensures you only get this page and everything nested under it
# rather than the whole site
alias wgetsite='wget --no-parent -p -r'

alias lg='lazygit'
alias y='yazi'

if ! command -v code >/dev/null 2>&1 && command -v codium >/dev/null 2>&1; then
  alias code="codium"
fi
