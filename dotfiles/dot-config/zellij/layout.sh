#!/bin/zsh

run_local() {
  selected=$(
    find . -type f | grep -E "\.local/layouts/(.*)\.kdl" |
      fzf --scheme=path --tiebreak=end,index --header "Open zellij layout"
  )
  [ -z $selected ] && return
  zellij -l $selected
}
