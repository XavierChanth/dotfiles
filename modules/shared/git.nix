{...}: {
  programs.git = {
    enable = true;
    delta.enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
