{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/shared/packages.nix
    ../../modules/shared/shell.nix
    ../../modules/shared/git.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
