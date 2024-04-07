#!/bin/zsh

set keyseq-timeout 0

export XDG_CONFIG_HOME="$HOME/.config"
export TMUX_CONF="$XDG_CONFIG_HOME/tmux/tmux.conf"

export EDITOR="nvim"
export VISUAL="nvim"

is_darwin() {
	[ "$(uname)" = 'Darwin' ]
}

source $XDG_CONFIG_HOME/zsh/alias.zsh
source $XDG_CONFIG_HOME/zsh/atsign.zsh
source $XDG_CONFIG_HOME/zsh/commands.zsh

if command -v git &> /dev/null; then
  source $XDG_CONFIG_HOME/zsh/git.zsh
fi

if is_darwin; then
  source $XDG_CONFIG_HOME/zsh/iterm2.zsh;
  if command -v brew &> /dev/null; then
    source $XDG_CONFIG_HOME/zsh/brew.zsh
    [[ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  else 
    echo "Brew not found"
  fi
fi

if command -v asdf &> /dev/null; then
  source $XDG_CONFIG_HOME/zsh/asdf.zsh;
fi

export PATH="$HOME/.local/bin:$PATH"

