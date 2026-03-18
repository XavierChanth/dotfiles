{...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    initContent = ''
      source "$HOME/.config/zsh/init.zsh"
    '';
    syntaxHighlighting.enable = true;
  };
}
