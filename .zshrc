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
source $XDG_CONFIG_HOME/zsh/git.zsh

if is_darwin; then
  source $XDG_CONFIG_HOME/zsh/brew.zsh;
  source $XDG_CONFIG_HOME/zsh/iterm2.zsh;
  source $XDG_CONFIG_HOME/zsh/prog.zsh;
fi

export PATH="$HOME/.local/bin:$PATH"

