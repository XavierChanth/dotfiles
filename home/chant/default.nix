{config, hostname, lib, pkgs, username, ...}: {
  imports = [
    ../../modules/home/nb.nix
    ../../modules/home/stow.nix
    ../../modules/home/darwin-applications.nix
    ../../modules/shared/claude.nix
    ../../modules/shared/cliproxy.nix
    ../../modules/shared/ghostty.nix
    ../../modules/shared/git.nix
    ../../modules/shared/identities.nix
    ../../modules/shared/packages.nix
    ../../modules/shared/shell.nix
    ../../modules/shared/ssh.nix
    ../../modules/shared/tmux.nix
  ];

  home = {
    inherit username;
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "25.05";
    sessionPath = [
      "${config.home.homeDirectory}/.dotfiles/bin/shared"
      "${config.home.homeDirectory}/.dotfiles/bin/hosts/${hostname}"
    ];
    sessionVariables.EDITOR = "nvim";
    file.".config/spaceship-prompt".source = "${pkgs.spaceship-prompt}/lib/spaceship-prompt";
  };

  programs.home-manager.enable = true;
}
