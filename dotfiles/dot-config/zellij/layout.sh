#!/bin/bash

run_local() {
  selected=$(
    find ".local/layouts/" -type f |
      fzf --scheme=path --tiebreak=end,index --header add-session
  )
  [ -z $selected ] && return
  zellij -l $selected
}
