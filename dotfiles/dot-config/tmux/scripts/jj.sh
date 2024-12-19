#!/usr/bin/env bash

root="$(git rev-parse --show-toplevel)"

# create a vertical split in the sshnpd dir
tmux neww -c "$root"
tmux splitw -l "40" -hbc "$root" "hwatch -tc -n 1 JJ_CONFIG=$HOME/.config/jj/config.toml jj log-watch"
tmux select-pane -R

# move the window to #2 and focus
tmux movew -b -t :2
tmux selectw -t :2
