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

alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# tmux
alias t='tmux' 
# use fzf to select and kill tmux session
alias tks="tmux ls | fzf -m | awk -F':' '{print \$1}' | xargs -I{} tmux kill-session -t {}"
alias vks="tmux ls | grep '^_' | fzf -m | awk -F':' '{print \$1}' | xargs -I{} tmux kill-session -t {}"

# Sessionizers
alias fzf_projects="find $HOME/src $HOME/dev -mindepth 0 -maxdepth 2 -type d | fzf --scheme=path --tiebreak=end,index"
alias c='selected=$(fzf_projects) || return 1 && cd $selected'
alias vv='selected=$(fzf_projects) || return 1 && cd $selected; DISABLE_AUTO_TITLE="true" echo -e "\033];nvim - $selected\007";nvim;DISABLE_AUTO_TITLE="false";'

