run_layout() {
  find $HOME/.local/tmux/layouts/ -type f |
    fzf --header "Run Layout" --preview 'tmux capture-pane -pt {}' |
    xargs -I % sh %
}
