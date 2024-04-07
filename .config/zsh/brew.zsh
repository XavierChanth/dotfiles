#!/bin/zsh
if ! command -v brew &>/dev/null; then
  echo "couldn't find brew"
  exit
fi
export PATH="/opt/homebrew/bin:$PATH"

# PS1 theme
source $(brew --prefix)/opt/spaceship/spaceship.zsh
export SPACESHIP_CONDA_SHOW=false
export SPACESHIP_GCLOUD_SHOW=false

# completion
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

autoload -Uz compinit
compinit

. "$(brew --prefix asdf)/libexec/asdf.sh"

export HOMEBREW_NO_ENV_HINTS=true
