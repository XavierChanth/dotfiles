#!/bin/zsh

# Off by default, only when explicitly enabled
SPACESHIP_JJ_LOG_SHOW="${SPACESHIP_JJ_LOG_SHOW=false}"
SPACESHIP_JJ_LOG_ASYNC="${SPACESHIP_JJ_LOG_ASYNC=true}"

function spaceship_jj_log() {
  [[ $SPACESHIP_JJ_LOG_SHOW == false ]] && return
  output="$(jj log -n 5 --color=always)"
  spaceship::section::v4 --suffix "\n" "$output"
}
