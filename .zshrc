#!/bin/zsh

set keyseq-timeout 0

export XDG_CONFIG_HOME="$HOME/.config"
export TMUX_CONF="$XDG_CONFIG_HOME/tmux/tmux.conf"

export EDITOR="nvim"
export VISUAL="nvim"

source $XDG_CONFIG_HOME/spaceship-prompt/spaceship.zsh
SPACESHIP_GCLOUD_SHOW=false
SPACESHIP_HOST_SHOW="always"

is_darwin() {
	[ "$(uname)" = 'Darwin' ]
}
is_darwin=$(is_darwin)

source $XDG_CONFIG_HOME/zsh/alias.zsh
source $XDG_CONFIG_HOME/zsh/atsign.zsh
source $XDG_CONFIG_HOME/zsh/commands.zsh

if command -v git &> /dev/null; then
  source $XDG_CONFIG_HOME/zsh/git.zsh
fi

if $is_darwin; then
  source $XDG_CONFIG_HOME/zsh/iterm2.zsh;

  if command -v brew &> /dev/null; then
    export PATH="/opt/homebrew/bin:$PATH"
    export HOMEBREW_NO_ENV_HINTS=true
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    [[ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
fi

source $XDG_CONFIG_HOME/zsh/asdf.zsh;

autoload -Uz compinit
compinit
export PATH="$HOME/.local/bin:$PATH"

