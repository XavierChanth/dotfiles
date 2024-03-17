#!/bin/zsh

# you probably think this is dumb right?
# well... it actually does something really cool
# it makes it so that you can use sudo with other aliases
alias sudo='sudo '

alias ls='ls --color'
alias ll='ls -lh'
alias la='ls -lah'

alias x64='arch -x86_64'
alias s='source $HOME/.zshrc'
alias q='exit'

#cd
alias ss='cd ~/src'
c() {
  selected=$(find $HOME/src $HOME/dev -mindepth 0 -maxdepth 2 -type d  | cat - <(echo $HOME/src $HOME/dev) | fzf)
  if [ -z "$selected" ]; then
    return
  fi
  cd $selected;
}

# tmux
# TODO: replace this with some better sessionizer stuff maybe tmux-sessionx?
alias t='tmux' 
# use fzf to select and kill tmux session
alias tks="tmux ls | fzf -m | awk -F':' '{print \$1}' | xargs -I{} tmux kill-session -t {}"
alias vks="tmux ls | grep '^_' | fzf -m | awk -F':' '{print \$1}' | xargs -I{} tmux kill-session -t {}"


