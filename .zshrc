#!/bin/bash

set keyseq-timeout 0

# basic exports
export XDG_CONFIG_HOME="$HOME/.config"
export ASDF_DIR="$HOME/.local/asdf"
export TMUX_CONF="$XDG_CONFIG_HOME/tmux/tmux.conf"


# prompt
source $XDG_CONFIG_HOME/spaceship-prompt/spaceship.zsh
SPACESHIP_GCLOUD_SHOW=false
SPACESHIP_HOST_SHOW="always"

  is_darwin=$([ "$(uname)" = 'Darwin' ]) 

# plugins
source $XDG_CONFIG_HOME/zsh/vi-mode.sh
source $XDG_CONFIG_HOME/zsh/alias.sh
source $XDG_CONFIG_HOME/zsh/atsign.sh
source $XDG_CONFIG_HOME/zsh/commands.sh

if command -v git &> /dev/null; then
  source $XDG_CONFIG_HOME/zsh/git.sh
fi

if $is_darwin; then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  if command -v brew &> /dev/null; then
    export PATH="/opt/homebrew/bin:$PATH"
    export HOMEBREW_NO_ENV_HINTS=true
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    [[ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
fi

source $XDG_CONFIG_HOME/zsh/asdf.sh;

autoload -Uz compinit
compinit
export PATH="$HOME/.local/bin:$PATH"

