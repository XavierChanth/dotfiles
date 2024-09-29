fzf_layout() {
  find $HOME/.config/tmux/layouts -type f |
    fzf --header "Run Layout" --preview 'tmux capture-pane -pt {}' |
    xargs -I % sh %
}
